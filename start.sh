#!/bin/sh

if [ "$WIKI_CONTEXT" != "" ];then
  if [ ! -f "${JETTY_BASE}/webapps/${WIKI_CONTEXT}" ];then
    mv ${JETTY_BASE}/webapps/ROOT ${JETTY_BASE}/webapps/${WIKI_CONTEXT}

    DB_OPTIONAL=''
    DB_DRIVER_CLASS=''
    DB_DIALECT=''

    case ${DB_TYPE} in
      'hsqldb')
        DB_DIALECT='org.hibernate.dialect.HSQLDialect'
        DB_DRIVER_CLASS='org.hsqldb.jdbcDriver'
        DB_HOST='jdbc:hsqldb:file:${environment.permanentDirectory}/database/xwiki;shutdown=true'
      ;;
      'mysql')
        DB_DIALECT='org.hibernate.dialect.MySQLDialect'
        DB_DRIVER_CLASS='com.mysql.jdbc.Driver'
        DB_HOST="jdbc:mysql://${DB_HOST}/xwiki?useServerPrepStmts=false\&amp;sessionVariables=sql_mode=''"
      ;;
      'oracle')
        DB_DIALECT='org.hibernate.dialect.Oracle10gDialect'
        DB_DRIVER_CLASS='oracle.jdbc.driver.OracleDriver'
        DB_HOST="jdbc:oracle:thin:${DB_HOST}:1521:xwiki"
        DB_OPTIONAL='<property name="hibernate.connection.SetBigStringTryClob">true</property><property name="hibernate.jdbc.batch_size">0</property>'
      ;;
      'postgresql')
        DB_DIALECT='org.hibernate.dialect.PostgreSQLDialect'
        DB_DRIVER_CLASS='org.postgresql.Driver'
        DB_HOST="jdbc:postgresql://${DB_HOST}/xwiki"
      ;;
    esac

    sed -i "s|DB_HOST|${DB_HOST}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|DB_USER|${DB_USER}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|DB_PASSWORD|${DB_PASSWORD}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|DB_DRIVER_CLASS|${DB_DRIVER_CLASS}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|DB_DIALECT|${DB_DIALECT}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml
    sed -i "s|DB_OPTIONAL|${DB_OPTIONAL}|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/hibernate.cfg.xml

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

    set XWIKI_OPTS=%XWIKI_OPTS% -Doffice.path=/usr/lib/libreoffice/

    sed -i "s|.*openoffice.serverType=0|openoffice.serverType=0|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    sed -i "s|.*openoffice.autoStart=false|openoffice.autoStart=true|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    sed -i "s|.*openoffice.homePath=/opt/openoffice.org3/|openoffice.homePath=/usr/lib/libreoffice/|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
    sed -i "s|.*openoffice.taskExecutionTimeout=30000|openoffice.taskExecutionTimeout=120000|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties

    sed -i "s|.*environment.permanentDirectory=/var/local/xwiki/|environment.permanentDirectory=/var/local/xwiki/|" ${JETTY_BASE}/webapps/${WIKI_CONTEXT}/WEB-INF/xwiki.properties
  fi
fi

cd ${JETTY_BASE}
java -jar start.jar
