FROM ruby:3.0.4
RUN bundle config --global frozen 0

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash && \
    apt-get update && apt-get install -y python2.7 nodejs mariadb-client cron yarn --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ENV APP_PATH /usr/src/app
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile* $APP_PATH/
RUN gem update --system && bundle install
COPY . $APP_PATH/

EXPOSE 3000