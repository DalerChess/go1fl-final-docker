FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /parcel-tracker .

FROM alpine:3.20

WORKDIR /app

COPY --from=builder /parcel-tracker ./parcel-tracker
COPY --from=builder /app/tracker.db ./tracker.db

CMD ["./parcel-tracker"]
