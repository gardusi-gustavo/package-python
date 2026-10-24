# syntax=docker/dockerfile:1
FROM debian:bookworm-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends bash ca-certificates git curl sed \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /repo
