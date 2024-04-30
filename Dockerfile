FROM ruby:3.0

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY .env.development.example .env.development
COPY .env.test.example .env.test

COPY app/ ./app/
COPY spec/ ./spec/

CMD ["ruby", "./app/app.rb"]
