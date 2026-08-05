# --- Этап 1: сборка приложения ---
FROM golang:1.22 AS builder

WORKDIR /app

# Сначала копируем только файлы зависимостей, чтобы слой с go mod download
# кешировался и не пересобирался при каждом изменении кода
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код и собираем статический бинарник.
# CGO_ENABLED=0 можно использовать, потому что modernc.org/sqlite — чистый Go
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /parcel-tracker .

# --- Этап 2: финальный образ ---
FROM alpine:3.20

WORKDIR /app

# Копируем из этапа сборки только бинарник и базу данных
COPY --from=builder /parcel-tracker ./parcel-tracker
COPY --from=builder /app/tracker.db ./tracker.db

CMD ["./parcel-tracker"]
