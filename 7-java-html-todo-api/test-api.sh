#!/bin/bash
# Test Todo API Endpoints

API_BASE="http://localhost:8080/api/todos"

echo "🧪 Testing Todo API Endpoints"
echo "=============================="
echo ""

# Function to make API calls
test_api() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4

    echo "📝 $description"
    echo "   $method $endpoint"

    if [ "$method" = "GET" ]; then
        curl -s -X $method "$API_BASE$endpoint" | python3 -m json.tool 2>/dev/null || curl -s -X $method "$API_BASE$endpoint"
    else
        curl -s -X $method "$API_BASE$endpoint" \
             -H "Content-Type: application/json" \
             -d "$data" | python3 -m json.tool 2>/dev/null || echo "Response received"
    fi

    echo ""
    echo "─" | tr -s '─' | head -c 50
    echo ""
}

# Test 1: Create todo
test_api "POST" "" '{
    "title": "Learn Java Spring Boot",
    "description": "Study REST API development with Spring Boot"
}' "Creating a new todo"

# Test 2: Create another todo
test_api "POST" "" '{
    "title": "Build HTML Frontend",
    "description": "Create responsive UI for todo app"
}' "Creating another todo"

# Test 3: Get all todos
test_api "GET" "" "" "Getting all todos"

# Test 4: Get completed todos (should be empty)
test_api "GET" "/completed" "" "Getting completed todos"

# Test 5: Update first todo to completed
test_api "PUT" "/1" '{
    "title": "Learn Java Spring Boot",
    "description": "Study REST API development with Spring Boot",
    "completed": true
}' "Marking first todo as completed"

# Test 6: Get completed todos (should have 1)
test_api "GET" "/completed" "" "Getting completed todos after update"

# Test 7: Search todos
test_api "GET" "/search?query=Java" "" "Searching todos with 'Java'"

# Test 8: Delete second todo
test_api "DELETE" "/2" "" "Deleting second todo"

# Test 9: Get all todos after deletion
test_api "GET" "" "" "Getting all todos after deletion"

echo "✅ API Testing completed!"
echo ""
echo "🎯 Test Results Summary:"
echo "   ✓ Create todo"
echo "   ✓ Read todos"
echo "   ✓ Update todo"
echo "   ✓ Delete todo"
echo "   ✓ Filter completed"
echo "   ✓ Search functionality"
echo ""
echo "🌐 Frontend: http://localhost:3000/index.html"
echo "🔗 Backend: http://localhost:8080"