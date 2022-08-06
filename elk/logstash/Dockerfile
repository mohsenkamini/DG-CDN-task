FROM registry.wanpad.ir:443/elk/logstash:7.14.0
USER root
ARG ELK_INSTANCE=
COPY ./InstallCert.java /crts/InstallCert.java
RUN update-ca-trust force-enable
COPY ./WANPAD.crt /etc/pki/ca-trust/source/anchors/WANPAD.crt
RUN update-ca-trust extract
WORKDIR /crts/
RUN java InstallCert.java ${ELK_INSTANCE}:443 --quiet
RUN cp /crts/jssecacerts $JAVA_HOME/lib/security/cacerts
USER logstash
WORKDIR /usr/share/logstash
