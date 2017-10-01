FROM centos:7

ENV ELASTIC_CONTAINER true
ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk

ARG http_proxy=""
ENV http_proxy $http_proxy

RUN yum update -y \
    && yum install -y java-1.8.0-openjdk-headless wget which openssl apr \
    && yum clean all \
    # Install gosu
    && gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

RUN groupadd -g 1000 elasticsearch && adduser -u 1000 -g 1000 -d /usr/share/elasticsearch elasticsearch

WORKDIR /usr/share/elasticsearch

USER elasticsearch

# Install elasticsearch
ARG elkver
RUN curl -fsSL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$elkver.tar.gz | \
    tar zx --strip-components=1

RUN set -ex && for esdirs in config data logs; do \
        mkdir -p "$esdirs"; \
    done

# Install searchguard
ARG sgver
RUN for PLUGIN in ingest-user-agent ingest-geoip com.floragunn:search-guard-5:$sgver; do \
      elasticsearch-plugin install --batch "$PLUGIN"; \
    done

RUN wget https://bintray.com/floragunncom/netty-tcnative/download_file?file_path=netty-tcnative-openssl-1.0.2-dynamic-2.0.1.Final-fedora-linux-x86_64.jar \
        -O plugins/search-guard-5/netty-tcnative-openssl-1.0.2-dynamic-2.0.1.Final-fedora-linux-x86_64.jar

ADD configs/elasticsearch.yml config/
ADD certs/ config/certs
ADD sgconfig/ config/sgconfig
ADD bin/docker-entrypoint.sh .
ADD bin/run.sh .

ENV http_proxy ""

USER root
RUN chmod 0755 docker-entrypoint.sh run.sh plugins/search-guard-5/tools/sgadmin.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["./run.sh"]

EXPOSE 9200 9300
