
# Use Alpine as the base image
FROM alpine:latest

# Install required packages: openjdk and wget
RUN apk add --no-cache openjdk11 wget tar && \
    mkdir -p /opt/tomcat

# Set environment variables for Tomcat
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk \
    CATALINA_HOME=/opt/tomcat \
    PATH=$CATALINA_HOME/bin:$PATH

# Download and extract Tomcat
ARG TOMCAT_VERSION=9.0.98
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat --strip-components=1 && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
