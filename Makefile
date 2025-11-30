.PHONY: dev serve build test format clean help install

# Default target
.DEFAULT_GOAL := help

## dev: Start development server with hot reload
dev:
	@echo "Starting development server with hot reload..."
	@echo "Watching for changes in src/**/*.gleam"
	@watchexec -e gleam -r -c --stop-signal SIGKILL --debounce 300 -- gleam run

## serve: Start production server (no hot reload)
serve:
	@echo "Starting server..."
	@gleam run

## build: Build the project
build:
	@echo "Building project..."
	@gleam build

## test: Run tests
test:
	@echo "Running tests..."
	@gleam test

## format: Format code
format:
	@echo "Formatting code..."
	@gleam format

## clean: Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf build

## install: Install dependencies
install:
	@echo "Installing dependencies..."
	@gleam deps download

## help: Show this help message
help:
	@echo "Available commands:"
	@echo ""
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'
