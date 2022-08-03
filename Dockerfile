FROM ruby:2.7.6-alpine3.15
RUN gem install aws-sdk-s3 --version '=1.114.0'
WORKDIR /app
COPY . .
