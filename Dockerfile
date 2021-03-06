FROM amazonlinux:2.0.20181010

WORKDIR /zap

RUN yum install -y curl wget unzip tar git python-pip git java-1.8.0-openjdk vim procps

ARG RELEASE=2018-10-22
RUN echo "Installing $RELEASE " && \
wget -q https://github.com/zaproxy/zaproxy/releases/download/w$RELEASE/ZAP_WEEKLY_D-$RELEASE.zip && \	
    unzip -q *.zip && \
	rm *.zip && \
	cp -R ZAP*/* . &&  \
	rm -R ZAP* && tail -n2 zap.sh

RUN pip install boto3 moto[server] && pip install -I --install-option="--prefix=/zap/py" urllib3 python-owasp-zap-v2.4 setuptools && \
  mv /zap/py/lib/python2.7/site-packages /zap/vendor && \
  rm -rf /zap/py

COPY zap_lambda.py  /zap/zap_lambda.py
COPY zap_common.py  /zap/zap_common.py
COPY run_local.sh /zap/run_local.sh

ENV PATH /zap/:$PATH
ENV ZAP_PATH /zap/zap.sh