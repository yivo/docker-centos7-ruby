FROM centos:7

# http://bundler.io/man/bundle-config.1.html
ENV GEM_HOME=/usr/local/rubygems \
    BUNDLE_PATH=/usr/local/rubygems \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	PATH="/usr/local/rubygems/bin:$PATH"

RUN yum -y update \
 && yum -y install epel-release \
 && yum -y update \
 && yum -y install gcc make openssl-devel libyaml-devel readline-devel zlib-devel gdbm-devel ncurses-devel jemalloc-devel libffi-devel yum-plugin-remove-with-leaves \
 && curl https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz | tar xz -C /tmp \
 && cd /tmp/ruby-2.4.2/ \
 && ./configure --enable-shared --disable-install-doc --with-jemalloc \
 && make -j $(nproc) \
 && make install \
 && cd - \
 && rm -rf /tmp/ruby* \
 && yum -y remove gcc make epel-release --remove-leaves \
 && yum -y remove yum-plugin-remove-with-leaves \
 && yum clean all \
 && rm -rf /var/cache/yum \
 && echo "gem: --no-document" >> /root/.gemrc \
 && mkdir -p "$GEM_HOME" \
 && chmod 775 "$GEM_HOME" \
 && gem update --system \
 && gem install bundler
