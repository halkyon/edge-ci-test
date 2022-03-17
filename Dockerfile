FROM storjlabs/ci

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get --yes --quiet install \
    ant \
    apt-transport-https \
    build-essential \
    ca-certificates \
    ca-certificates-mono \
    curl \
    dirmngr \
    dnsmasq \
    git \
    gnupg \
    jq \
    libevent-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libunwind8 \
    libxml2-dev \
    libxslt-dev \
    libbz2-dev \
    openjdk-11-jdk \
    openjdk-11-jdk-headless \
    php \
    php-curl \
    php-xml \
    python3 \
    python3-pip \
    ruby \
    ruby-dev \
    ruby-bundler \
    wget \
    zlib1g-dev

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

ENV PYENV_ROOT /.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN curl -sfL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

ENV S3TEST_CONF=/s3-tests/splunk.conf

COPY ./splunk-s3-tests /s3-tests
RUN cd /s3-tests && \
    pyenv install 2.7.18 && \
    pyenv virtualenv 2.7.18 s3-tests && \
    pyenv local s3-tests && \
    pip install --upgrade pip && \
    pip install setuptools && \
    pip install -r requirements.txt && \
    python setup.py develop

ENV MINT_ROOT_DIR /mint

COPY ./gateway-mint /mint
COPY ./build-mint.sh /mint
RUN cd /mint && /mint/build-mint.sh

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
