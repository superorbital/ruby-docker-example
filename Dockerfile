FROM ruby:2.7-alpine

ARG REPO
LABEL "org.opencontainers.image.source"="$REPO"

WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install -j 8

ADD . /app
