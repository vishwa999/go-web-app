
# First stage: Build Go application
FROM golang:1.22.5 as base

WORKDIR /app

COPY go.mod . 
RUN go mod download

COPY . .
RUN go build -o main .

# Final stage: Use NGINX and distroless
FROM nginx:alpine as nginx

# Copy NGINX configuration
RUN rm -rf /usr/share/nginx/html/*

# Use distroless for the application
FROM gcr.io/distroless/base

# Copy static files and binary from the Go build stage
COPY --from=base /app/main /main
COPY --from=base /app/static /static

# Expose the necessary ports
EXPOSE 8080

# Run the Go application and NGINX
CMD ["./main"]
