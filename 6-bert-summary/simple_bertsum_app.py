#!/usr/bin/env python3
"""
Simplified BertSum Web App - No Training Required
Uses pre-trained BERT for extractive text summarization
"""

from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
import torch
from transformers import BertTokenizer, BertModel
import numpy as np
from sklearn.cluster import KMeans
import os

app = Flask(__name__)
CORS(app)

# Global variables for models
tokenizer = None
model = None

def load_models():
    """Load BERT models (with caching)"""
    global tokenizer, model

    try:
        print("Loading BERT models...")
        # Use local cache if available
        cache_dir = os.path.expanduser("~/.cache/huggingface/transformers")
        os.makedirs(cache_dir, exist_ok=True)

        tokenizer = BertTokenizer.from_pretrained(
            'bert-base-uncased',
            cache_dir=cache_dir,
            local_files_only=True  # Use only local files
        )
        model = BertModel.from_pretrained(
            'bert-base-uncased',
            cache_dir=cache_dir,
            local_files_only=True  # Use only local files
        )
        print("✅ Models loaded from cache")
        return True
    except Exception as e:
        print(f"❌ Error loading from cache: {e}")
        try:
            print("Trying to download models...")
            tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
            model = BertModel.from_pretrained('bert-base-uncased')
            print("✅ Models downloaded and loaded")
            return True
        except Exception as e2:
            print(f"❌ Error downloading models: {e2}")
            return False

def split_into_sentences(text):
    """Simple sentence splitting"""
    import re
    sentences = re.split(r'[.!?]+', text)
    return [s.strip() for s in sentences if s.strip()]

def get_sentence_embeddings(sentences):
    """Get BERT embeddings for sentences"""
    if not tokenizer or not model:
        return None

    embeddings = []
    model.eval()

    with torch.no_grad():
        for sentence in sentences:
            if len(sentence) < 10:  # Skip very short sentences
                continue

            inputs = tokenizer(sentence, return_tensors='pt',
                             truncation=True, max_length=512,
                             padding=True)

            outputs = model(**inputs)
            # Use [CLS] token embedding
            embedding = outputs.last_hidden_state[:, 0, :].squeeze().numpy()
            embeddings.append(embedding)

    return np.array(embeddings) if embeddings else None

def summarize_text(text, num_sentences=3):
    """Summarize text using BERT embeddings and clustering"""
    if not text or len(text.strip()) < 50:
        return "Text too short for summarization"

    sentences = split_into_sentences(text)
    if len(sentences) <= num_sentences:
        return text  # Return original if already short

    # Get embeddings
    embeddings = get_sentence_embeddings(sentences)
    if embeddings is None or len(embeddings) == 0:
        # Fallback: return first few sentences
        return '. '.join(sentences[:num_sentences]) + '.'

    # Use clustering to find representative sentences
    try:
        # Determine number of clusters (sentences to select)
        n_clusters = min(num_sentences, len(embeddings))

        kmeans = KMeans(n_clusters=n_clusters, random_state=42, n_init=10)
        cluster_labels = kmeans.fit_predict(embeddings)

        # Find sentences closest to cluster centers
        selected_sentences = []
        for i in range(n_clusters):
            cluster_points = embeddings[cluster_labels == i]
            center = kmeans.cluster_centers_[i]

            # Find closest point to center
            distances = np.linalg.norm(cluster_points - center, axis=1)
            closest_idx = np.argmin(distances)

            # Get original sentence index
            cluster_indices = np.where(cluster_labels == i)[0]
            original_idx = cluster_indices[closest_idx]

            selected_sentences.append((original_idx, sentences[original_idx]))

        # Sort by original order
        selected_sentences.sort(key=lambda x: x[0])
        summary = '. '.join([s[1] for s in selected_sentences]) + '.'

        return summary

    except Exception as e:
        print(f"Clustering error: {e}")
        # Fallback: return first few sentences
        return '. '.join(sentences[:num_sentences]) + '.'

# HTML Template moved to templates/index.html

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/summarize', methods=['POST'])
def summarize():
    try:
        data = request.get_json()
        text = data.get('text', '').strip()
        num_sentences = data.get('num_sentences', 2)

        if not text:
            return jsonify({'error': 'No text provided'})

        if len(text) < 50:
            return jsonify({'error': 'Text too short (minimum 50 characters)'})

        summary = summarize_text(text, num_sentences)

        return jsonify({
            'summary': summary,
            'original_length': len(text),
            'summary_length': len(summary)
        })

    except Exception as e:
        return jsonify({'error': str(e)})

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'models_loaded': tokenizer is not None and model is not None
    })

if __name__ == '__main__':
    print("🚀 Starting BertSum Simplified Web App...")
    print("📥 Loading models...")

    if load_models():
        print("✅ Models loaded successfully!")
        print("🌐 Starting server on http://localhost:5001")
        print("📝 Open your browser and start summarizing!")
        app.run(host='0.0.0.0', port=5001, debug=False)
    else:
        print("❌ Failed to load models. Please check your internet connection.")
        print("💡 Try: pip install torch transformers --upgrade")
        exit(1)