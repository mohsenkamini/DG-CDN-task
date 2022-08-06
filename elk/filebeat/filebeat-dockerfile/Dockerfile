FROM registry.wanpad.ir:443/elk/custom-filebeat:7.14.0
USER root
RUN update-ca-trust force-enable
COPY ./ca.crt /etc/pki/ca-trust/source/anchors/WANPAD.crt
RUN update-ca-trust extract
RUN usermod -a -G adm filebeat
