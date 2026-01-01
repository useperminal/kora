FROM rust:1.80 as builder
WORKDIR /usr/src/app
COPY . .
RUN cargo build --release --bin kora

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /usr/src/app/target/release/kora /usr/local/bin/
COPY kora.toml /app/kora.toml
COPY signers.toml /app/signers.toml
EXPOSE 8080
CMD ["kora", "rpc", "--config", "/app/kora.toml", "--signers", "/app/signers.toml"]
