#!/bin/bash

if [ "$WIKI_CONTEXT" != "" ];then 
  if [ ! -f "${JETTY_BASE}/webapps/${WIKI_CONTEXT}" ];then
    mv ${JETTY_BASE}/webapps/ROOT ${JETTY_BASE}/webapps/${WIKI_CONTEXT}
    #curl http://download.forge.ow2.org/xwiki/xwiki-enterprise-web-8.0-milestone-2.war --output webapps/xwiki8.war
    sed -i "s|MYSQL_HOST|${MYSQL_HOST}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|MYSQL_USER|${MYSQL_USER}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|MYSQL_PASSWORD|${MYSQL_PASSWORD}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
  fi
fi

java -jar "$JETTY_HOME/start.jar" 

