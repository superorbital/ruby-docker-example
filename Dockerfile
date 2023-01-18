FROM ruby:2.7-alpine

LABEL org.opencontainers.image.source = "https://github.com/superorbital/ruby-docker-example"

WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install -j 8

ADD . /app
