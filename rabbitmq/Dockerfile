FROM rabbitmq:3-management

ADD bin/docker-entrypoint.sh /usr/local/bin
ADD bin/run.sh /usr/local/bin

RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh /usr/local/bin/run.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["run.sh"]
