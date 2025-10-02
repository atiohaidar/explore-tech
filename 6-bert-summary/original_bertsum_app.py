#!/usr/bin/env python3
"""
Original-Style BertSum Web App - Using Pretrained Models
Combines BERT embeddings + pretrained summarization models
"""

from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import torch
from transformers import (
    BertTokenizer, BertModel,
    T5Tokenizer, T5ForConditionalGeneration,
    BartTokenizer, BartForConditionalGeneration,
    pipeline
)
import numpy as np
from sklearn.cluster import KMeans
import os

app = Flask(__name__)
CORS(app)

# Global variables for models
bert_tokenizer = None
bert_model = None
summarizer_model = None
summarizer_tokenizer = None

def load_bert_models():
    """Load BERT models for sentence embeddings"""
    global bert_tokenizer, bert_model

    try:
        print("Loading BERT models...")
        cache_dir = os.path.expanduser("~/.cache/huggingface/transformers")
        os.makedirs(cache_dir, exist_ok=True)

        bert_tokenizer = BertTokenizer.from_pretrained(
            'bert-base-uncased',
            cache_dir=cache_dir,
            local_files_only=True
        )
        bert_model = BertModel.from_pretrained(
            'bert-base-uncased',
            cache_dir=cache_dir,
            local_files_only=True
        )
        print("✅ BERT models loaded from cache")
        return True
    except Exception as e:
        print(f"❌ Error loading BERT from cache: {e}")
        try:
            print("Downloading BERT models...")
            bert_tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
            bert_model = BertModel.from_pretrained('bert-base-uncased')
            print("✅ BERT models downloaded and loaded")
            return True
        except Exception as e2:
            print(f"❌ Error downloading BERT models: {e2}")
            return False

def load_summarizer_model(model_name='t5-small'):
    """Load pretrained summarization model"""
    global summarizer_model, summarizer_tokenizer

    try:
        print(f"Loading {model_name} summarization model...")

        if 't5' in model_name.lower():
            summarizer_tokenizer = T5Tokenizer.from_pretrained(model_name)
            summarizer_model = T5ForConditionalGeneration.from_pretrained(model_name)
        elif 'bart' in model_name.lower():
            summarizer_tokenizer = BartTokenizer.from_pretrained(model_name)
            summarizer_model = BartForConditionalGeneration.from_pretrained(model_name)
        else:
            # Use pipeline for other models
            summarizer_model = pipeline('summarization', model=model_name, device='cpu')
            summarizer_tokenizer = None

        print(f"✅ {model_name} model loaded successfully")
        return True
    except Exception as e:
        print(f"❌ Error loading {model_name}: {e}")
        return False

def split_into_sentences(text):
    """Simple sentence splitting"""
    import re
    sentences = re.split(r'[.!?]+', text)
    return [s.strip() for s in sentences if s.strip()]

def get_sentence_embeddings(sentences):
    """Get BERT embeddings for sentences"""
    if not bert_tokenizer or not bert_model:
        return None

    embeddings = []
    bert_model.eval()

    with torch.no_grad():
        for sentence in sentences:
            if len(sentence) < 10:  # Skip very short sentences
                continue

            inputs = bert_tokenizer(sentence, return_tensors='pt',
                                   truncation=True, max_length=512,
                                   padding=True)

            outputs = bert_model(**inputs)
            # Use [CLS] token embedding
            embedding = outputs.last_hidden_state[:, 0, :].squeeze().numpy()
            embeddings.append(embedding)

    return np.array(embeddings) if embeddings else None

def extractive_summarize(text, num_sentences=3):
    """Extractive summarization using BERT + clustering (like simplified BertSum)"""
    if not text or len(text.strip()) < 50:
        return "Text too short for summarization"

    sentences = split_into_sentences(text)
    if len(sentences) <= num_sentences:
        return text

    # Get embeddings
    embeddings = get_sentence_embeddings(sentences)
    if embeddings is None or len(embeddings) == 0:
        return '. '.join(sentences[:num_sentences]) + '.'

    # Use clustering to find representative sentences
    try:
        n_clusters = min(num_sentences, len(embeddings))
        kmeans = KMeans(n_clusters=n_clusters, random_state=42, n_init=10)
        cluster_labels = kmeans.fit_predict(embeddings)

        # Find sentences closest to cluster centers
        selected_sentences = []
        for i in range(n_clusters):
            cluster_points = embeddings[cluster_labels == i]
            center = kmeans.cluster_centers_[i]

            distances = np.linalg.norm(cluster_points - center, axis=1)
            closest_idx = np.argmin(distances)

            cluster_indices = np.where(cluster_labels == i)[0]
            original_idx = cluster_indices[closest_idx]

            selected_sentences.append((original_idx, sentences[original_idx]))

        # Sort by original order
        selected_sentences.sort(key=lambda x: x[0])
        summary = '. '.join([s[1] for s in selected_sentences]) + '.'

        return summary

    except Exception as e:
        print(f"Clustering error: {e}")
        return '. '.join(sentences[:num_sentences]) + '.'

def abstractive_summarize(text, model_type='t5'):
    """Abstractive summarization using pretrained models"""
    if not summarizer_model:
        return "Summarization model not loaded"

    try:
        # Check if using pipeline (has __class__.__name__ attribute)
        if hasattr(summarizer_model, '__class__') and 'Pipeline' in summarizer_model.__class__.__name__:
            # Using pipeline
            result = summarizer_model(text, max_length=150, min_length=30, do_sample=False)
            return result[0]['summary_text']
        else:
            # Using direct model
            inputs = summarizer_tokenizer("summarize: " + text, return_tensors="pt", max_length=512, truncation=True)

            with torch.no_grad():
                if 't5' in model_type.lower():
                    outputs = summarizer_model.generate(
                        inputs.input_ids,
                        max_length=150,
                        min_length=30,
                        num_beams=4,
                        early_stopping=True
                    )
                else:  # BART
                    outputs = summarizer_model.generate(
                        inputs.input_ids,
                        max_length=150,
                        min_length=30,
                        num_beams=4,
                        early_stopping=True
                    )

            summary = summarizer_tokenizer.decode(outputs[0], skip_special_tokens=True)
            return summary

    except Exception as e:
        print(f"Summarization error: {e}")
        return f"Error generating summary: {str(e)}"

def hybrid_summarize(text, num_sentences=2, use_abstractive=True):
    """Hybrid approach: Extractive selection + Abstractive generation"""
    try:
        # First, do extractive summarization to get key sentences
        extractive_summary = extractive_summarize(text, num_sentences)

        if not use_abstractive or not summarizer_model:
            return extractive_summary

        # Then use abstractive model to refine/improve the summary
        refined_summary = abstractive_summarize(extractive_summary, 't5')

        return refined_summary

    except Exception as e:
        print(f"Hybrid summarization error: {e}")
        return extractive_summarize(text, num_sentences)

@app.route('/')
def home():
    return render_template('original_index.html')

@app.route('/summarize', methods=['POST'])
def summarize():
    try:
        data = request.get_json()
        text = data.get('text', '').strip()
        num_sentences = data.get('num_sentences', 2)
        method = data.get('method', 'extractive')  # extractive, abstractive, hybrid

        if not text:
            return jsonify({'error': 'No text provided'})

        if len(text) < 50:
            return jsonify({'error': 'Text too short (minimum 50 characters)'})

        # Choose summarization method
        if method == 'abstractive':
            summary = abstractive_summarize(text, 't5')
        elif method == 'hybrid':
            summary = hybrid_summarize(text, num_sentences, use_abstractive=True)
        else:  # extractive (default)
            summary = extractive_summarize(text, num_sentences)

        return jsonify({
            'summary': summary,
            'method': method,
            'original_length': len(text),
            'summary_length': len(summary)
        })

    except Exception as e:
        return jsonify({'error': str(e)})

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'bert_loaded': bert_tokenizer is not None and bert_model is not None,
        'summarizer_loaded': summarizer_model is not None
    })

@app.route('/models')
def get_available_models():
    """Get list of available pretrained models"""
    return jsonify({
        'extractive': ['bert-clustering (no training required)'],
        'abstractive': [
            't5-small', 't5-base', 't5-large',
            'facebook/bart-large-cnn',
            'google/pegasus-xsum'
        ],
        'hybrid': ['bert-selection + t5-refinement']
    })

if __name__ == '__main__':
    print("🚀 Starting Original-Style BertSum Web App...")
    print("=" * 60)
    print("This version uses pretrained models without training!")
    print()

    # Load BERT for extractive summarization
    if not load_bert_models():
        print("❌ Failed to load BERT models")
        exit(1)

    # Load T5 for abstractive summarization
    if not load_summarizer_model('t5-small'):
        print("⚠️  T5 model failed to load, but BERT extractive will still work")

    print("✅ Models loaded successfully!")
    print("🌐 Starting server on http://localhost:5001")
    print()
    print("📝 Available summarization methods:")
    print("   • Extractive: BERT + clustering (like simplified BertSum)")
    print("   • Abstractive: T5/BART pretrained models")
    print("   • Hybrid: Extractive selection + Abstractive refinement")
    print()
    print("🎯 Open your browser and start summarizing!")

    app.run(host='0.0.0.0', port=5001, debug=False)