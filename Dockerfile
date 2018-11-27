FROM ruby:2.4.4-stretch

RUN apt-get update \
  && apt-get install python3 python3-pip curl git sudo cron -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/taku910/mecab.git
WORKDIR /opt/mecab/mecab
RUN ./configure  --enable-utf8-only \
  && make \
  && make check \
  && make install \
  && ldconfig

WORKDIR /opt/mecab/mecab-ipadic
RUN ./configure --with-charset=utf8 \
  && make \
  && make install

WORKDIR /opt
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
WORKDIR /opt/mecab-ipadic-neologd
RUN ./bin/install-mecab-ipadic-neologd -n -y

# install app
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN bundle install

ENV RUBYOPT -EUTF-8
CMD bundle exec ruby main.rb
