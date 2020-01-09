# golang builder
FROM golang:latest as builder

LABEL maintainer="Galih Rivanto <galih.rivanto@gmail.com>"

# working directory inside container
WORKDIR /app

# copy go mod and sum files
COPY go.mod go.sum ./

# download dependencies
RUN go mod download

# copy source to working dir
COPY . .

# build
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# start target
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# copy prebuild binary from prev stage
COPY --from=builder /app/main .

# expose port 8080
EXPOSE 8080

# run app
CMD ["./main"]