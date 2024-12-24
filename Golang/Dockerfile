FROM golang:1.23

RUN go install -v github.com/go-delve/delve/cmd/dlv@latest

# Install Delve (Go Debugger)
RUN go install -v github.com/go-delve/delve/cmd/dlv@latest

# Install gopls (Go Language Server) and staticcheck
RUN go install golang.org/x/tools/gopls@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest

# Install Go plugins for gRPC and Protobuf
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

RUN apt-get update && apt-get install -y protobuf-compiler

WORKDIR /go/src/app

CMD ["bash"]
