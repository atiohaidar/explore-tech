#!/bin/bash

# Script untuk insert data todo menggunakan curl
# Pastikan backend sudah running di http://localhost:3001

BACKEND_URL="http://localhost:3001"

echo "Inserting sample todo data..."

# Insert beberapa todo
echo "1. Creating todo: 'Belajar NestJS'"
curl -X POST "$BACKEND_URL/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Belajar NestJS"}' \
  && echo -e "\n"

echo "2. Creating todo: 'Belajar Nuxt.js'"
curl -X POST "$BACKEND_URL/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Belajar Nuxt.js"}' \
  && echo -e "\n"

echo "3. Creating todo: 'Setup MongoDB'"
curl -X POST "$BACKEND_URL/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Setup MongoDB"}' \
  && echo -e "\n"

echo "4. Creating todo: 'Buat API CRUD'"
curl -X POST "$BACKEND_URL/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Buat API CRUD"}' \
  && echo -e "\n"

echo "5. Creating todo: 'Design UI Frontend'"
curl -X POST "$BACKEND_URL/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Design UI Frontend"}' \
  && echo -e "\n"

echo "Sample todos inserted successfully!"
echo ""
echo "Untuk melihat semua todos:"
echo "curl $BACKEND_URL/todo"
echo ""
echo "Untuk melihat todo tertentu (ganti ID):"
echo "curl $BACKEND_URL/todo/[ID]"
echo ""
echo "Untuk update todo (ganti ID):"
echo "curl -X PUT $BACKEND_URL/todo/[ID] -H 'Content-Type: application/json' -d '{\"completed\": true}'"
echo ""
echo "Untuk delete todo (ganti ID):"
echo "curl -X DELETE $BACKEND_URL/todo/[ID]"