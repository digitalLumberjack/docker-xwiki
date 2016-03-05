#!/bin/bash

if [ "$WIKI_CONTEXT" != "" ];then 
  if [ ! -f "${JETTY_BASE}/webapps/${WIKI_CONTEXT}" ];then
    mv ${JETTY_BASE}/webapps/ROOT ${JETTY_BASE}/webapps/${WIKI_CONTEXT}
    #curl http://download.forge.ow2.org/xwiki/xwiki-enterprise-web-8.0-milestone-2.war --output webapps/xwiki8.war
    sed -i "s|MYSQL_HOST|${MYSQL_HOST}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|MYSQL_USER|${MYSQL_USER}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|MYSQL_PASSWORD|${MYSQL_PASSWORD}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    if [[ "${SMTP_HOST}" != "" ]]; then
      sed -i "s|.*mail\.sender\.host = .*|mail.sender.host = ${SMTP_HOST}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties 
    fi
    if [[ "${SMTP_LOGIN}" != "" ]]; then
      sed -i "s|.*mail\.sender\.username = .*|mail.sender.username = ${SMTP_LOGIN}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    fi
    if [[ "${SMTP_PASSWORD}" != "" ]]; then
      sed -i "s|.*mail\.sender\.password = .*|mail.sender.password = ${SMTP_PASSWORD}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    fi
    if [[ "${ADMIN_EMAIL}" != "" ]]; then
      sed -i "s|.*mail\.sender\.from = .*|mail.sender.from = ${ADMIN_EMAIL}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    fi
    if [[ "${SMTP_PROTOCOL}" == "tls" ]]; then
      sed -i "s|.*mail\.sender\.port = .*|mail.sender.port = 587|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
      sed -i "s|.*mail\.sender\.properties = .*|mail.sender.properties = mail.smtp.starttls.enable = true|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    elif [[ "${SMTP_PROTOCOL}" == "ssl" ]]; then
      sed -i "s|.*mail\.sender\.port = .*|mail.sender.port = 465|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    else
      sed -i "s|.*mail\.sender\.port = .*|mail.sender.port = 25|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    fi
  fi
fi

java -jar "$JETTY_HOME/start.jar" 

