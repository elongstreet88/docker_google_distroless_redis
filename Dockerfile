# Stage 1 - Build Redis
FROM debian:latest AS builder

RUN apt-get update
RUN apt-get install -y build-essential wget

WORKDIR /build
RUN wget http://download.redis.io/redis-stable.tar.gz
RUN tar -xzf redis-stable.tar.gz
WORKDIR /build/redis-stable
RUN make
RUN make install

# Stage 2 - Copy Redis to Distroless
FROM gcr.io/distroless/base
COPY --from=builder /build/redis-stable/src/redis-server /app/
CMD ["./app/redis-server"]
