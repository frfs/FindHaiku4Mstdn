FROM ruby:2.4.4-stretch

# install app
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN bundle install

RUN apt-get update \
  && apt-get install git mecab libmecab-dev mecab-ipadic-utf8 make curl xz-utils file -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
WORKDIR /opt/mecab-ipadic-neologd
RUN ./bin/install-mecab-ipadic-neologd -n -y

ENV RUBYOPT -EUTF-8
CMD bundle exec ruby main.rb