FROM ruby:3.0

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY .env.example ./
RUN mv .env.example .env

COPY queke_log_parser.rb ./
COPY entities/ ./
COPY enumerators/ ./
COPY reports/ ./
COPY spec/ ./
COPY strategies/ ./

CMD ["ruby", "queke_log_parser.rb"]
