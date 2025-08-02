package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHelloHandler(t *testing.T) {
	tests := []struct {
		name     string
		query    string
		expected string
	}{
		{
			name:     "with name parameter",
			query:    "?name=Alice",
			expected: "Hello, Alice!\n",
		},
		{
			name:     "without name parameter",
			query:    "",
			expected: "Hello, World!\n",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			req := httptest.NewRequest("GET", "/hello"+tt.query, nil)
			w := httptest.NewRecorder()

			HelloHandler(w, req)

			if w.Body.String() != tt.expected {
				t.Errorf("expected %q, got %q", tt.expected, w.Body.String())
			}
		})
	}
}

func TestHealthHandler(t *testing.T) {
	req := httptest.NewRequest("GET", "/health", nil)
	w := httptest.NewRecorder()

	HealthHandler(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("expected status %d, got %d", http.StatusOK, w.Code)
	}

	if w.Body.String() != "OK" {
		t.Errorf("expected %q, got %q", "OK", w.Body.String())
	}
}
