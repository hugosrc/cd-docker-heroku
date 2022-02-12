FROM golang:1.17.1-alpine AS builder

WORKDIR /go/src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN GOOS=linux go build -o server main.go

FROM alpine:3.14

WORKDIR /app

COPY --from=builder /go/src/server server
COPY --from=builder /go/src/templates templates
COPY --from=builder /go/src/static static

EXPOSE 8080
CMD [ "./server" ]
