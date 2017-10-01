FROM centos:7

ARG http_proxy=""
ENV http_proxy $http_proxy

RUN yum update -y && yum install -y java-1.8.0-openjdk-devel which && \
    yum clean all

RUN groupadd --gid 1000 logstash && \
    adduser --uid 1000 --gid 1000 \
      --home-dir /usr/share/logstash --no-create-home \
      logstash

RUN curl -Lo - https://artifacts.elastic.co/downloads/logstash/logstash-5.5.1.tar.gz | \
    tar zxf - -C /usr/share && \
    mv /usr/share/logstash-5.5.1 /usr/share/logstash && \
    chown --recursive logstash:logstash /usr/share/logstash/ && \
    ln -s /usr/share/logstash /opt/logstash

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/logstash/bin:$PATH

RUN for PLUGIN in logstash-filter-cidr; do \
      logstash-plugin install "$PLUGIN"; \
    done

ADD config/logstash.yml /usr/share/logstash/config/logstash.yml
ADD config/log4j2.properties /usr/share/logstash/config/
ADD certs/truststore.jks /usr/share/logstash/
RUN chown --recursive logstash:logstash /usr/share/logstash/config/

ENV LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8'

ADD bin/docker-entrypoint env2yaml/env2yaml /usr/local/bin/
RUN chmod 0755 /usr/local/bin/docker-entrypoint /usr/local/bin/env2yaml

ENV http_proxy ""

EXPOSE 9600 5044

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
