# Use a lightweight base image with Java
FROM openjdk:11-jre-slim

# Set environment variables
ENV IDP_VERSION=4.3.3
ENV TOMCAT_VERSION=9.0.91
ENV IDP_HOME=/opt/shibboleth-idp
ENV CATALINA_HOME=/opt/tomcat

# Install necessary packages
RUN apt-get update && \
    apt-get install -y unzip wget

# Copy Shibboleth and Tomcat ZIP files into the image
COPY shibboleth-identity-provider-${IDP_VERSION}.zip /opt/
COPY apache-tomcat-${TOMCAT_VERSION}.tar.gz /opt/

# Extract the Shibboleth IdP ZIP file
RUN unzip /opt/shibboleth-identity-provider-${IDP_VERSION}.zip -d /opt && \
    rm /opt/shibboleth-identity-provider-${IDP_VERSION}.zip && \
    mv /opt/shibboleth-identity-provider-${IDP_VERSION} ${IDP_HOME}

# Extract and install Tomcat
RUN tar -xzf /opt/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /usr/local && \
    mv /usr/local/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    rm /opt/apache-tomcat-${TOMCAT_VERSION}.tar.gz &&\
    mkdir ${CATALINA_HOME}/webapps/idp/

# Copy IdP to Tomcat webapps
RUN cp -r ${IDP_HOME}/webapp/* ${CATALINA_HOME}/webapps/idp/

# Expose necessary ports
EXPOSE 8080 8443

# Set the working directory
WORKDIR $IDP_HOME

# Add the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

