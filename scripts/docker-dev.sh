#!/bin/bash

# Billiard Club Management System - Docker Development Script
# This script provides common Docker operations for development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to build and start services
start_services() {
    print_status "Building and starting services..."
    docker-compose up --build -d
    print_success "Services started successfully"
}

# Function to stop services
stop_services() {
    print_status "Stopping services..."
    docker-compose down
    print_success "Services stopped"
}

# Function to restart services
restart_services() {
    print_status "Restarting services..."
    docker-compose down
    docker-compose up --build -d
    print_success "Services restarted"
}

# Function to view logs
view_logs() {
    local service=${1:-"backend"}
    print_status "Viewing logs for $service..."
    docker-compose logs -f $service
}

# Function to view all logs
view_all_logs() {
    print_status "Viewing all logs..."
    docker-compose logs -f
}

# Function to access database
access_db() {
    print_status "Accessing PostgreSQL database..."
    docker-compose exec postgres psql -U bida_user -d bida_db
}

# Function to reset database
reset_db() {
    print_warning "This will delete all data in the database!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Resetting database..."
        docker-compose down -v
        docker-compose up --build -d
        print_success "Database reset complete"
    else
        print_status "Database reset cancelled"
    fi
}

# Function to check service health
check_health() {
    print_status "Checking service health..."
    
    # Check PostgreSQL
    if docker-compose exec postgres pg_isready -U bida_user -d bida_db > /dev/null 2>&1; then
        print_success "PostgreSQL is healthy"
    else
        print_error "PostgreSQL is not healthy"
    fi
    
    # Check Backend
    if curl -f http://localhost:8080/api/v1/actuator/health > /dev/null 2>&1; then
        print_success "Backend is healthy"
    else
        print_error "Backend is not healthy"
    fi
}

# Function to show service status
show_status() {
    print_status "Service status:"
    docker-compose ps
}

# Function to clean up
cleanup() {
    print_status "Cleaning up Docker resources..."
    docker-compose down -v --remove-orphans
    docker system prune -f
    print_success "Cleanup complete"
}

# Function to show help
show_help() {
    echo "Billiard Club Management System - Docker Development Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start       Build and start all services"
    echo "  stop        Stop all services"
    echo "  restart     Restart all services"
    echo "  logs        View backend logs"
    echo "  logs-all    View all service logs"
    echo "  db          Access PostgreSQL database"
    echo "  reset-db    Reset database (delete all data)"
    echo "  health      Check service health"
    echo "  status      Show service status"
    echo "  cleanup     Clean up Docker resources"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs backend"
    echo "  $0 health"
}

# Main script logic
main() {
    check_docker
    
    case "${1:-help}" in
        start)
            start_services
            ;;
        stop)
            stop_services
            ;;
        restart)
            restart_services
            ;;
        logs)
            view_logs $2
            ;;
        logs-all)
            view_all_logs
            ;;
        db)
            access_db
            ;;
        reset-db)
            reset_db
            ;;
        health)
            check_health
            ;;
        status)
            show_status
            ;;
        cleanup)
            cleanup
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
