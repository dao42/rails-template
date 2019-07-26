FROM ruby:2.5.1

ENV DEBIAN_FRONTEND noninteractive

RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com

RUN mv /etc/apt/sources.list /etc/apt/sources.list.orig \
&& echo "deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian/ stretch-proposed-updates main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/debian/ stretch-proposed-updates main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib" >> /etc/apt/sources.list \
&& echo "deb-src http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib" >> /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y apt-utils git-core curl zlib1g-dev build-essential libssl-dev \
    ca-certificates \
    postgresql postgresql-contrib \
    libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev \
    software-properties-common libffi-dev mysql-client default-libmysqlclient-dev tmux apt-transport-https --no-install-recommends \
    locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

#different strange error may raise because of networking problem, change to different network may solve them.
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install -y nodejs

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN gem install rails -v 6.0.0.rc1

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

RUN yarn config set registry https://registry.npm.taobao.org/ && rm -rf /node_modules

RUN npm config rm proxy && npm config rm https-proxy

RUN yarn config set sass-binary-site http://npm.taobao.org/mirrors/node-sass

RUN yarn install --no-bin-links

RUN mkdir /app

WORKDIR /app

EXPOSE 3000

LABEL maintainer="Sherllo Chen <sherllochen@gmail.com>"

CMD ["/bin/bash"]
