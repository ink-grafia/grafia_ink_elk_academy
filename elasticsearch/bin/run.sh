#!/bin/bash

declare -a es_opts
while IFS='=' read -r envvar_key envvar_value
do
    # Elasticsearch env vars need to have at least two dot separated lowercase words, e.g. `cluster.name`
    if [[ "$envvar_key" =~ ^[a-z_]+\.[a-z_]+ ]]
    then
        if [[ ! -z $envvar_value ]]; then
          es_opt="-E${envvar_key}=${envvar_value}"
          es_opts+=("${es_opt}")
        fi
    fi
done < <(env)

export ES_JAVA_OPTS="-Des.cgroups.hierarchy.override=/ $ES_JAVA_OPTS"
echo "ES_OPTS: ${es_opts[@]}"
echo "ES_JAVA_OPTS: $ES_JAVA_OPTS"

if [ "$sgadmin" = "1" ]; then
    exec elasticsearch "${es_opts[@]}" &
    sleep 25
    # plugins/search-guard-5/tools/sgadmin.sh -cd config/sgconfig -nhnv -icl
    plugins/search-guard-5/tools/sgadmin.sh -cd config/sgconfig -ks config/certs/spock-keystore.p12 -kst PKCS12 -kspass changeit \
        -ts config/certs/truststore.jks -tst JKS -tspass changeit -nhnv -icl
    # plugins/search-guard-5/tools/sgadmin.sh -cd config/sgconfig -cacert config/certs/GraphieCA/root-ca.crt -cert config/certs/admin.crt -key config/certs/admin.key -keypass adminpp -nhnv -icl
    # plugins/search-guard-5/tools/sgadmin.sh -cd config/sgconfig -cacert config/certs/ca/root-ca.pem -cert config/certs/admin.crtfull.pem \
    #     -key config/certs/admin.key.pem -ts config/certs/truststore.jks -tspass changeit -nhnv -icl
else
    exec elasticsearch "${es_opts[@]}"
fi
