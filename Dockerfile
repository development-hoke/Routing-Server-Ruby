FROM ruby:2.5.3

RUN apt-get update -q \
&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
&& apt-get install -y nodejs \
&& npm i -g redoc-cli

RUN mkdir /app
RUN mkdir /docs
ENV APP_ROOT /app
WORKDIR $APP_ROOT

ADD ./src/Gemfile $APP_ROOT/Gemfile
ADD ./src/Gemfile.lock $APP_ROOT/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD ./src $APP_ROOT
ADD ./openapi.yml /docs/openapi.yml

# redoc.html を生成しておく (ローカルでは別途 ./redoc.sh で生成必要)
RUN if [ ! -e $APP_ROOT/public ]; then \
mkdir $APP_ROOT/public && redoc-cli bundle /docs/openapi.yml -o $APP_ROOT/public/redoc.html \
else :; fi
