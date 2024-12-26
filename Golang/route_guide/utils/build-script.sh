#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory of the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Define variables relative to the script's location
ROOT_DIR="$SCRIPT_DIR/.."
PROTO_DIR="$ROOT_DIR/routeguide"
PROTO_FILE="$PROTO_DIR/route_guide.proto"
OUTPUT_DIR="$ROOT_DIR/build"
BIN_DIR="$OUTPUT_DIR/bin"
PROTO_OUTPUT="$OUTPUT_DIR/proto"
SERVER_SRC="$ROOT_DIR/server/server.go"
CLIENT_SRC="$ROOT_DIR/client/client.go"
SERVER_BINARY="$BIN_DIR/server"
CLIENT_BINARY="$BIN_DIR/client"

rm -rf "$OUTPUT_DIR"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$PROTO_OUTPUT"

# Run the protoc command with the --proto_path (-I) flag
protoc \
    -I "$PROTO_DIR" \
    --go_out="$PROTO_OUTPUT" --go_opt=paths=source_relative \
    --go-grpc_out="$PROTO_OUTPUT" --go-grpc_opt=paths=source_relative \
    "$PROTO_FILE"

# Print success message for protoc
echo "Protobuf files compiled successfully to $PROTO_OUTPUT"

# Build the server binary
echo "Building the server..."
go build -o "$SERVER_BINARY" "$SERVER_SRC"

# Build the client binary
echo "Building the client..."
go build -o "$CLIENT_BINARY" "$CLIENT_SRC"

# Print success message for builds
echo "Server and Client binaries compiled successfully to $OUTPUT_DIR"
