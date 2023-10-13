source file: ex1.go

`docker build -t ex1 . -f Dockerfile`

### Description:

1. ex1:latest  841MB Dockerfile original one build step. image size 841MB

2. ex1:stage  Dockerfile-2 seprate build stages. image size 79.6MB

3. ex1:stage2 Dockerfile-2 add .dockerignore at the same directory. image size 79.6MB

4. ex1:stage3 Dockerfile-3 Use Alpine with 2 build stages. image size 9.14MB.

5. ex1:stage4 Dockerfile-4 Use build FROM scratch syntax. image size 1.8MB.

### Environment:

- Windows11 with WSL2 (Ubuntu 22.04)

- golang 1.21.1 linux/amd64

- Docker Desktop under windows with WSL2 as backend.

- IDE tool: Microsoft VS code
