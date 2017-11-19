# docker-centos7-ruby

Docker container with CentOS 7 and Ruby.

[View on Docker Hub](https://hub.docker.com/r/eahome00/centos7-ruby/)

## Tags

* `2.4.2`: CentOS 7.4.1708 and Ruby 2.4.2

## How to use

```
FROM eahome00/centos7-ruby:2.4.2

ENV APP=/home/web/app

ADD . $APP
WORKDIR $APP

RUN bundle install --without development test --deployment --jobs $(nproc) \
 && useradd -r -d /home/web web \
 && chown -R web:web /home/web

USER web

CMD ["bundle", "exec", "rails", "s", "--port=3000", "--binding=0.0.0.0"]
```

## How to build

```
docker build --rm -t centos7-ruby .
```

## How to run

```
docker run -it --rm centos7-ruby /bin/bash
```
