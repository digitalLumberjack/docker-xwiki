# docker-xwiki

Create a xwiki instance with jetty webserver

Use the following ENV when running :
- DB_TYPE : the type of database. Supported databases : HSQLDB / Oracle / MySQL / PostgreSQL. HSQLDB is stored in the folder defined by the XWiki environment.permanentDirectory variable.
- DB_USER : the database user (not needed for HSQLDB)
- DB_PASSWORD : the database password (not needed for HSQLDB)
- DB_HOST : the hostname of the linked database container (not needed for hsqldb)
- WIKI_CONTEXT : the context of the website (ROOT for no context)
- ADMIN_EMAIL : the email of the administrator
- SMTP_HOST : smtp host to send email from
- SMTP_PROTOCOL : smtp protocol (tls, ssl, unsecure)
- SMTP_LOGIN : the smtp login (empty if no login needed)
- SMTP_PASSWORD : the smtp password (empty if no login needed)
