FROM elastic/filebeat:7.14.0
USER root
RUN update-ca-trust force-enable
COPY ./ca.crt /etc/pki/ca-trust/source/anchors/ca.crt
RUN update-ca-trust extract
RUN usermod -a -G adm filebeat
USER filebeat
