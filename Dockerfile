
FROM tutum/lamp

RUN apt-get update && \
	apt-get upgrade -q -y && \
	apt-get install -q -y curl php5-gd php5-ldap php5-imap sendmail php5-pgsql php5-curl && \
	apt-get clean && \
	php5enmod imap

RUN rm -rf /app
ADD limesurvey3.tar.bz2 /
RUN mv limesurvey app; \
	mkdir -p /uploadstruct; \
	chown -R www-data:www-data /app

RUN cp -r /app/upload/* /uploadstruct ; \
	chown -R www-data:www-data /uploadstruct

RUN chown www-data:www-data /var/lib/php5

ADD apache_default /etc/apache2/sites-available/000-default.conf
ADD start.sh /
ADD run.sh /

RUN chmod +x /start.sh && \
    chmod +x /run.sh

VOLUME /app/upload

EXPOSE 80 3306
CMD ["/start.sh"]
