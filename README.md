# docker-xwiki

Create a xwiki instance with jetty webserver

Use the following ENV when running :
- MYSQL_USER : the mysql user
- MYSQL_PASSWORD : the mysql password
- MYSQL_HOST : the hostname of the linked database container
- WIKI_CONTEXT : the context of the website (ROOT for no context)
- ADMIN_EMAIL : the email of the administrator
- SMTP_HOST : smtp host to send email from
- SMTP_PROTOCOL : smtp protocol (tls, ssl, unsecure)
- SMTP_LOGIN : the smtp login (empty if no login needed)
- SMTP_PASSWORD : the smtp password (empty if no login needed)
