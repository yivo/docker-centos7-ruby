# docker-centos7-ruby

Docker container with CentOS 7 and Ruby.

<a href="https://hub.docker.com/r/eahome00/centos7-ruby/" target="_blank">View on Docker Hub</a>

## Ruby build features

Ruby is compiled with shared libraries enabled and <a href="https://github.com/jemalloc/jemalloc" target="_blank">jemalloc memory allocator</a>.

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

## How to pull and run

```
container=eahome00/centos7-ruby:2.4.2 \
  && docker pull $container \
  && docker run -it $container /bin/bash
```

## How to build and run

```
git clone git@github.com:yivo/docker-centos7-ruby.git \
  && cd docker-centos7-ruby \
  && docker build --rm -t centos7-ruby . \
  && docker run -it centos7-ruby /bin/bash
```
