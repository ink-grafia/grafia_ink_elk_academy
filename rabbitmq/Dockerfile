FROM rabbitmq:3-management

ARG http_proxy=""
ENV http_proxy $http_proxy
ENV https_proxy $http_proxy

ADD bin/docker-entrypoint.sh /usr/local/bin
ADD bin/run.sh /usr/local/bin

RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh /usr/local/bin/run.sh

ENV http_proxy ""
ENV https_proxy ""

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["run.sh"]
