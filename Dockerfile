FROM ruby:3.0

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "./app/app.rb"]
