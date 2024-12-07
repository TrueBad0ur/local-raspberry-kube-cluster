FROM golang:1.23-alpine as builder
WORKDIR /app
ADD app .
RUN go mod download
RUN go build -o pgbench ./main.go

FROM scratch
COPY --from=builder /app/pgbench /pgbench
CMD ["/pgbench"]
