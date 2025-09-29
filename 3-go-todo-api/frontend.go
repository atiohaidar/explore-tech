package main

import (
	"log"
	"net/http"
)

func main() {
	// Serve static files from current directory
	fs := http.FileServer(http.Dir("."))

	// Add CORS headers for API calls
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Set CORS headers
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		// Handle preflight OPTIONS requests
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		fs.ServeHTTP(w, r)
	})

	log.Println("🌐 Go Frontend server running on http://localhost:3000")
	log.Println("🔗 Backend API should be running on http://localhost:8080")
	log.Println("📱 Open browser to: http://localhost:3000")
	log.Fatal(http.ListenAndServe(":3000", handler))
}