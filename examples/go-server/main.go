package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

// HelloHandler handles HTTP requests to the hello endpoint
func HelloHandler(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "World"
	}
	
	fmt.Fprintf(w, "Hello, %s!\n", name)
}

// HealthHandler handles health check requests
func HealthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "OK")
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/hello", HelloHandler)
	http.HandleFunc("/health", HealthHandler)

	log.Printf("Server starting on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal("Server failed to start:", err)
	}
}
