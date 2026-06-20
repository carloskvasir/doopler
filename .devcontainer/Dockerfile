FROM docker.io/library/ruby:4.0.5

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      libsqlite3-dev \
      sqlite3 \
      git \
      curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
