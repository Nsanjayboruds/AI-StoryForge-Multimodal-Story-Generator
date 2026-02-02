#!/bin/bash

# Keploy Test Runner Script for AI-StoryForge Backend
# This script helps automate common Keploy testing tasks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Keploy is installed
check_keploy() {
    if ! command -v keploy &> /dev/null; then
        print_error "Keploy is not installed!"
        print_info "Install with: curl --silent --location 'https://github.com/keploy/keploy/releases/latest/download/keploy_linux_amd64.tar.gz' | tar xz -C /tmp && sudo mv /tmp/keploy /usr/local/bin"
        exit 1
    fi
    print_success "Keploy is installed ($(keploy --version))"
}

# Check if MongoDB is running
check_mongodb() {
    if ! pgrep -x "mongod" > /dev/null; then
        print_warning "MongoDB doesn't appear to be running"
        print_info "Start with: sudo systemctl start mongod"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "MongoDB is running"
    fi
}

# Check environment variables
check_env() {
    if [ ! -f .env ]; then
        print_error ".env file not found!"
        exit 1
    fi
    
    print_success ".env file found"
    
    # Check for required variables
    required_vars=("MONGO_URI" "JWT_SECRET" "GROQ_API_KEY")
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}=" .env; then
            print_warning "${var} not found in .env"
        fi
    done
}

# Record mode
record_tests() {
    print_info "Starting Keploy in RECORD mode..."
    print_info "Your API server will start, and all traffic will be recorded"
    print_info "Press Ctrl+C to stop recording"
    echo
    
    # Clean up old test data if requested
    if [ "$1" == "--clean" ]; then
        print_warning "Cleaning up old test data..."
        rm -rf keploy/tests/* keploy/mocks/*
        print_success "Old test data removed"
    fi
    
    keploy record -c "node index.js"
}

# Test mode
run_tests() {
    print_info "Starting Keploy in TEST mode..."
    
    # Check if tests exist
    if [ ! -d "keploy/tests" ] || [ -z "$(ls -A keploy/tests)" ]; then
        print_error "No test cases found!"
        print_info "Record tests first with: ./keploy-test.sh record"
        exit 1
    fi
    
    print_success "Found test cases in keploy/tests/"
    echo
    
    keploy test -c "node index.js" --delay 10
}

# Generate sample API calls
generate_sample_calls() {
    print_info "Generating sample API traffic..."
    print_warning "Make sure your server is running in record mode!"
    echo
    
    sleep 2
    
    BASE_URL="http://localhost:5000"
    
    # Test root endpoint
    print_info "Testing root endpoint..."
    curl -s $BASE_URL | jq 2>/dev/null || echo "Root endpoint tested"
    sleep 1
    
    # Test signup
    print_info "Testing signup..."
    SIGNUP_RESPONSE=$(curl -s -X POST $BASE_URL/api/signup \
        -H "Content-Type: application/json" \
        -d '{"email": "testuser@example.com", "password": "SecurePass123"}')
    echo $SIGNUP_RESPONSE | jq 2>/dev/null || echo $SIGNUP_RESPONSE
    sleep 1
    
    # Test login
    print_info "Testing login..."
    LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/api/login \
        -H "Content-Type: application/json" \
        -d '{"email": "testuser@example.com", "password": "SecurePass123"}')
    echo $LOGIN_RESPONSE | jq 2>/dev/null || echo $LOGIN_RESPONSE
    sleep 1
    
    # Test AI endpoint
    print_info "Testing AI story generation..."
    curl -s -X POST $BASE_URL/api/ai \
        -H "Content-Type: application/json" \
        -d '{"prompt": "Write a short story about a robot learning to paint", "model": "llama3-8b-8192"}' \
        | jq 2>/dev/null || echo "AI endpoint tested"
    sleep 1
    
    # Test image generation
    print_info "Testing image generation..."
    curl -s -X POST $BASE_URL/api/image \
        -H "Content-Type: application/json" \
        -d '{"prompt": "A futuristic cityscape at sunset"}' \
        | jq '.imageUrl' 2>/dev/null || echo "Image endpoint tested"
    sleep 1
    
    print_success "Sample API calls completed!"
    print_info "Stop the recording server (Ctrl+C) to save test cases"
}

# Show test results
show_results() {
    print_info "Test Results Summary:"
    echo
    
    if [ -d "keploy/tests" ]; then
        for test_set in keploy/tests/*/; do
            test_set_name=$(basename "$test_set")
            test_count=$(find "$test_set" -name "*.yaml" 2>/dev/null | wc -l)
            print_info "📁 $test_set_name: $test_count test(s)"
        done
    else
        print_warning "No test results found"
    fi
}

# Clean up
cleanup() {
    print_warning "Cleaning up Keploy test data..."
    read -p "Are you sure? This will delete all recorded tests! (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf keploy/
        print_success "Test data cleaned up"
    else
        print_info "Cleanup cancelled"
    fi
}

# Docker commands
docker_setup() {
    print_info "Setting up Docker environment for Keploy..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed!"
        exit 1
    fi
    
    print_info "Starting services with Docker Compose..."
    docker-compose -f docker-compose.keploy.yml up -d
    
    print_success "Services started!"
    print_info "View logs with: docker-compose -f docker-compose.keploy.yml logs -f"
}

docker_teardown() {
    print_info "Stopping Docker services..."
    docker-compose -f docker-compose.keploy.yml down
    print_success "Services stopped"
}

# Show usage
show_usage() {
    echo "🧪 Keploy Test Runner for AI-StoryForge Backend"
    echo
    echo "Usage: ./keploy-test.sh [command] [options]"
    echo
    echo "Commands:"
    echo "  check              Check prerequisites (Keploy, MongoDB, .env)"
    echo "  record             Start recording test cases"
    echo "  record --clean     Clean old tests and start recording"
    echo "  test               Run recorded tests"
    echo "  generate           Generate sample API traffic (run while recording)"
    echo "  results            Show test results summary"
    echo "  cleanup            Remove all test data"
    echo "  docker-up          Start services with Docker"
    echo "  docker-down        Stop Docker services"
    echo "  help               Show this help message"
    echo
    echo "Examples:"
    echo "  ./keploy-test.sh check          # Check if everything is set up"
    echo "  ./keploy-test.sh record         # Start recording tests"
    echo "  ./keploy-test.sh test           # Run recorded tests"
    echo "  ./keploy-test.sh docker-up      # Use Docker setup"
    echo
}

# Main script
main() {
    case "${1:-help}" in
        check)
            print_info "Checking prerequisites..."
            check_keploy
            check_mongodb
            check_env
            print_success "All checks passed!"
            ;;
        record)
            check_keploy
            check_env
            record_tests $2
            ;;
        test)
            check_keploy
            check_env
            run_tests
            ;;
        generate)
            generate_sample_calls
            ;;
        results)
            show_results
            ;;
        cleanup)
            cleanup
            ;;
        docker-up)
            docker_setup
            ;;
        docker-down)
            docker_teardown
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            echo
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
