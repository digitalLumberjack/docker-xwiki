FROM frolvlad/alpine-oraclejdk8

ARG XWIKI_VERSION=8.0
ARG JETTY_MAJOR=stable-9
ARG JETTY_VERSION=9.3.8.v20160314
ENV JETTY_BASE /usr/local/jetty

ENV MYSQL_USER xwiki
ENV MYSQL_PASSWORD dbpass
ENV MYSQL_HOST db
ENV WIKI_CONTEXT xwiki
ENV ADMIN_EMAIL ''
ENV SMTP_HOST ''
ENV SMTP_PROTOCOL ''
ENV SMTP_LOGIN ''
ENV SMTP_PASSWORD ''

RUN apk update && \
  apk add --no-cache libreoffice curl && \
  cd /usr/local && \
  curl -sSL "http://eclipse.org/downloads/download.php?file=/jetty/${JETTY_MAJOR}/dist/jetty-distribution-${JETTY_VERSION}.tar.gz&r=1" -o jetty.tar.gz && \
  tar -xzf jetty.tar.gz && \
  ln -s jetty-distribution-${JETTY_VERSION} jetty && \
  rm jetty.tar.gz


RUN curl -sL http://download.forge.ow2.org/xwiki/xwiki-enterprise-web-${XWIKI_VERSION}.war --output ${JETTY_BASE}/xwiki${XWIKI_VERSION}.war && \
  curl -sL http://download.forge.ow2.org/xwiki/xwiki-enterprise-ui-mainwiki-all-${XWIKI_VERSION}.xar --output ${JETTY_BASE}/xwiki${XWIKI_VERSION}.xar && \
  mkdir -p ${JETTY_BASE}/webapps/ROOT/ && \
  unzip -q ${JETTY_BASE}/xwiki${XWIKI_VERSION}.war -d ${JETTY_BASE}/webapps/ROOT/ && \
  rm ${JETTY_BASE}/xwiki${XWIKI_VERSION}.war && \
  curl -sL http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.38/mysql-connector-java-5.1.38.jar --output ${JETTY_BASE}/webapps/ROOT/WEB-INF/lib/mysql-connector-java-5.jar


RUN rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/share/doc/*

ADD ./start.sh /usr/local/bin/start.sh
ADD ./config/hibernate.cfg.xml ${JETTY_BASE}/webapps/ROOT/WEB-INF/
CMD ["/usr/local/bin/start.sh"]
