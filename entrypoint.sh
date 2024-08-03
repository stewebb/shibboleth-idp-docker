#!/bin/bash

# Initialize Shibboleth IdP if not already done
if [ ! -f "${IDP_HOME}/conf/idp.properties" ]; then
    /opt/shibboleth-identity-provider-${IDP_VERSION}/bin/install.sh \
        -Didp.src.dir=/opt/shibboleth-identity-provider-${IDP_VERSION} \
        -Didp.target.dir=${IDP_HOME} \
        -Didp.sealer.password.change=false \
        -Didp.host.name=localhost \
        -Didp.scope=example.org \
        -Didp.keystore.password=password
fi

# Start Tomcat
#ls /opt/apache-tomcat-${TOMCAT_VERSION}
#ls ${CATALINA_HOME}
exec ${CATALINA_HOME}/bin/catalina.sh run