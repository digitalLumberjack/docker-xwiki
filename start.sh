#!/bin/bash

#curl http://download.forge.ow2.org/xwiki/xwiki-enterprise-web-8.0-milestone-2.war --output webapps/xwiki8.war
sed -i "s|MYSQL_HOST|${MYSQL_HOST}|" ${JETTY_BASE}/webapps/ROOT/WEB-INF/hibernate.cfg.xml
sed -i "s|MYSQL_USER|${MYSQL_USER}|" ${JETTY_BASE}/webapps/ROOT/WEB-INF/hibernate.cfg.xml
sed -i "s|MYSQL_PASSWORD|${MYSQL_PASSWORD}|" ${JETTY_BASE}/webapps/ROOT/WEB-INF/hibernate.cfg.xml

java -jar "$JETTY_HOME/start.jar" 

