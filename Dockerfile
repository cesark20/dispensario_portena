FROM ruby:3.2.6

WORKDIR /app

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  curl && \
  npm install -g yarn && \
  yarn add jquery

COPY Gemfile Gemfile.lock ./

RUN yarn install

RUN gem install bundler && bundle install

COPY . .



COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]


EXPOSE 3000

CMD ["bin/rails", "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]