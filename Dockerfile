FROM ubuntu:16.04

RUN useradd -d /home/ubuntu -m -s /bin/bash ubuntu

ENV APP_ROOT /home/ubuntu/www/django_sample/

WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install vim \
                       git \
                       nginx \
                       postgresql \
                       libpq-dev \
                       python3-pip && \
    echo 'postgres:postgres' | chpasswd && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip install -U pip && \
    pip install Django==1.11.2 uwsgi psycopg2 && \
    ln -s /home/ubuntu/www/django_sample/django_sample_nginx.conf /etc/nginx/sites-enabled/

# bash から日本語入力できない症状への対処
RUN apt-get install -y language-pack-ja-base language-pack-ja
ENV LANG=ja_JP.UTF-8

USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "ALTER ROLE postgres WITH PASSWORD 'postgres';"

USER root