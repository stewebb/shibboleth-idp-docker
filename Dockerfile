# Use a lightweight base image with Java
FROM openjdk:11-jre-slim

ENV IDP_VERSION=4.3.3
ENV TOMCAT_VERSION=9.0.91
ENV IDP_HOME=/opt/shibboleth-idp
ENV CATALINA_HOME=/opt/tomcat

RUN apt-get update && \
    apt-get install -y unzip wget

COPY downloads/shibboleth-identity-provider-${IDP_VERSION}.zip /opt/
COPY downloads/apache-tomcat-${TOMCAT_VERSION}.tar.gz /opt/
#COPY config/idp.properties ${IDP_HOME}/conf/
#COPY config/login.config ${IDP_HOME}/conf/
#COPY config/attribute-resolver.xml ${IDP_HOME}/conf/
#COPY config/users.properties ${IDP_HOME}/conf/
#COPY config/idp-status.xml ${CATALINA_HOME}/conf/Catalina/localhost/idp-status.xml

# Extract Shibboleth IdP
RUN unzip /opt/shibboleth-identity-provider-${IDP_VERSION}.zip -d /opt
RUN rm /opt/shibboleth-identity-provider-${IDP_VERSION}.zip
RUN mv /opt/shibboleth-identity-provider-${IDP_VERSION} ${IDP_HOME}
    
# Extract Tomcat
RUN tar -xzf /opt/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt
RUN mv /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME}
RUN rm /opt/apache-tomcat-${TOMCAT_VERSION}.tar.gz
RUN mkdir ${CATALINA_HOME}/webapps/idp/

RUN mkdir /opt/cache/

COPY config/idp.properties ${IDP_HOME}/conf/
COPY config/login.config ${IDP_HOME}/conf/
COPY config/attribute-resolver.xml ${IDP_HOME}/conf/
COPY config/users.properties ${IDP_HOME}/conf/
#COPY config/access-control.xml ${IDP_HOME}/conf/
#COPY config/idp-status.xml ${CATALINA_HOME}/conf/Catalina/localhost/idp-status.xml

# Copy IdP to Tomcat webapps
RUN cp -r ${IDP_HOME}/webapp/* ${CATALINA_HOME}/webapps/idp/

EXPOSE 8080 8443

WORKDIR $IDP_HOME

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
