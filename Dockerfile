FROM ruby:2.4.4-jessie

RUN apt-get update

RUN apt-get install -y \
      bundler \
      fonts-linuxlibertine \
      inotify-tools \
      libcairo2-dev \
      libpango1.0-dev \
      pdftk \
      poppler-utils

#RUN apt-get clean 

ADD Gemfile /dependencies/Gemfile
ADD Gemfile.lock /dependencies/Gemfile.lock

RUN cd /dependencies && NOKOGIRI_USE_SYSTEM_LIBRARIES=1 bundle install 
RUN mkdir /workspace

WORKDIR /workspace

RUN ruby --version

add . /workspace
