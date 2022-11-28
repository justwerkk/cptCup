FROM ruby:1.9.3

WORKDIR /home/cptcup

RUN apt update --force-yes -y \
    && apt install --force-yes -y \
    lsb-release \
    nano \
    nodejs \
    npm \
    unixodbc \
    unixodbc-dev \
    wget \
    postgresql \
    postgresql-contrib



ENV BUNDLER_VERSION='1.17.3'
RUN gem install bundler -v $BUNDLER_VERSION