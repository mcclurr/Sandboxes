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
PROTO_OUTPUT="$OUTPUT_DIR/proto"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
mkdir -p "$PROTO_OUTPUT"

# Run the protoc command with the --proto_path (-I) flag
protoc \
    -I "$PROTO_DIR" \
    --go_out="$PROTO_OUTPUT" --go_opt=paths=source_relative \
    --go-grpc_out="$PROTO_OUTPUT" --go-grpc_opt=paths=source_relative \
    "$PROTO_FILE"

# Print success message
echo "Protobuf files compiled successfully to $PROTO_OUTPUT"
