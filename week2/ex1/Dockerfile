# syntax=docker/dockerfile:1
# original Dockerfile not optimized yet, image size 841MB
FROM golang:1.21
WORKDIR  /opt/app
COPY . .
RUN go mod init main && go build -o ex1
CMD ["/opt/app/ex1"]