#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the directory of the script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Define variables relative to the script's location
ROOT_DIR="$SCRIPT_DIR/.."
OUTPUT_DIR="$ROOT_DIR/build"
BIN_DIR="$OUTPUT_DIR/bin"

PROTO_DIR="$ROOT_DIR/protos"
PROTO_FILE="$PROTO_DIR/masterworker.proto"
PROTO_OUTPUT="$OUTPUT_DIR/proto"

MASTER_SRC="$ROOT_DIR/master/main.go"
WORKER_SRC="$ROOT_DIR/worker/main.go"
MASTER_BINARY="$BIN_DIR/master"
WORKER_BINARY="$BIN_DIR/worker"

CFG_NAME="config.ini"
CFG_DIR="$ROOT_DIR/configs"
CFG_FILE="$CFG_DIR/$CFG_NAME"
CFG_LINK="$BIN_DIR/$CFG_NAME"

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

# Build the master binary
echo "Building the master..."
go build -o "$MASTER_BINARY" "$MASTER_SRC"

# Build the worker binary
echo "Building the worker..."
go build -o "$WORKER_BINARY" "$WORKER_SRC"

# Create the symbolic link
ln -sfn "$CFG_FILE" "$CFG_LINK"

# Print success message for builds
echo "Master and Worker binaries compiled successfully to $OUTPUT_DIR"
