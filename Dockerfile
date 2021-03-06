FROM ruby:2.6-alpine AS base

RUN bundle config --global frozen 1

ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    HOME=/app

RUN apk add --no-cache \
        build-base \
        ca-certificates \
        curl \
        git \
        libffi-dev \
        postgresql-dev \
        tzdata \
        bash \
        less

WORKDIR /app/

COPY Gemfile* ./

RUN bundle install -j4 -r3

COPY . .
