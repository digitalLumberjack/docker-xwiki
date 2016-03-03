FROM jetty:9.3.7-jre8

ENV MYSQL_USER xwiki
ENV MYSQL_PASSWORD dbpass
ENV MYSQL_HOST db
ENV WIKI_CONTEXT xwiki

RUN curl http://download.forge.ow2.org/xwiki/xwiki-enterprise-web-8.0-milestone-2.war --output ${JETTY_BASE}/xwiki8.war
RUN curl http://download.forge.ow2.org/xwiki/xwiki-enterprise-ui-mainwiki-all-8.0-milestone-2.xar --output ${JETTY_BASE}/xwiki8.xar
RUN mkdir -p ${JETTY_BASE}/webapps/ROOT/
RUN unzip ${JETTY_BASE}/xwiki8.war -d ${JETTY_BASE}/webapps/ROOT/
RUN curl http://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.38/mysql-connector-java-5.1.38.jar --output ${JETTY_BASE}/webapps/ROOT/WEB-INF/lib/mysql-connector-java-5.jar

ADD ./start.sh /usr/local/bin/start.sh
ADD ./config/hibernate.cfg.xml ${JETTY_BASE}/webapps/ROOT/WEB-INF/
CMD ["/usr/local/bin/start.sh"]
