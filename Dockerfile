FROM storjlabs/ci

ENV DEBIAN_FRONTEND noninteractive
ENV MINT_ROOT_DIR /mint
ENV S3TEST_CONF=/s3-tests/splunk.conf

RUN apt-get --yes update && \
    apt-get --yes --quiet install \
        curl \
        dnsmasq \
        git \
        jq \
        libevent-dev \
        libxml2-dev \
        libxslt-dev \
        python2 \
        python3 \
        python3-pip \
        wget \
        zlib1g-dev

COPY ./gateway-mint /mint
RUN cd /mint && /mint/release.sh

COPY ./splunk-s3-tests /splunk-s3-tests
RUN cd /splunk-s3-tests && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    python setup.py develop

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
