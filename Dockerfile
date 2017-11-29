FROM centos:7

# http://bundler.io/man/bundle-config.1.html
ENV                    GEM_HOME=/usr/local/rubygems \
                    BUNDLE_PATH=/usr/local/rubygems \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
                           PATH="/usr/local/rubygems/bin:$PATH"

RUN yum -y update \
 \
 # Install CentOS Linux Software Collections release file.
 && yum -y install centos-release-scl \
 \
 # Install build tools.
 && yum -y install which file devtoolset-7-gcc devtoolset-7-make \
 \
 # Install system GCC compiler and make in order to allow native gem extensions to compile.
 && yum -y install gcc make \
 \
 # Enable EPEL repository (required to install jemalloc-devel) and update packages.
 && yum -y install epel-release \
 && yum -y update \
 \
 # Install Ruby dependencies.
 && yum -y install openssl-devel libyaml-devel readline-devel zlib-devel gdbm-devel ncurses-devel jemalloc-devel libffi-devel \
 \
 # Download Ruby source code.
 && curl -sL https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.2.tar.gz | tar xz -C /tmp \
 \
 # Build Ruby.
 && cd /tmp/ruby-2.4.2/ \
 && scl enable devtoolset-7 "./configure --enable-shared --disable-install-doc --with-jemalloc" \
 && scl enable devtoolset-7 "make -j $(nproc)" \
 && scl enable devtoolset-7 "make install" \
 \
 # Don't install documentation for gems.
 && echo "gem: --no-document" >> /root/.gemrc \
 \
 # Initialize RubyGems home directory.
 && mkdir -p $GEM_HOME \
 && chmod 775 $GEM_HOME \
 \
 # Check Ruby & RubyGems installation.
 && ruby -v \
 && gem -v \
 \
 # Update RubyGems.
 && gem update --system \
 \
 # Install Bundler.
 && gem install bundler \
 \
 # Check Bundler installation.
 && bundle -v \
 \
 # Cleanup.
 && cd / \
 && rm -rf /tmp/ruby* \
 && yum clean all \
 && rm -rf /var/cache/yum
