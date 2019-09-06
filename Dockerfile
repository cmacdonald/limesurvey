
FROM linuxconfig/lamp

RUN apt-get update && \
	apt-get upgrade -q -y && \
	apt-get install -q -y curl php-gd php-ldap php-imap sendmail php-pgsql php-curl  php-mbstring php-zip && \
	apt-get clean && \
	phpenmod imap


#copied from tutum/lamp
RUN a2enmod rewrite
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#Environment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

# Add volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]


RUN rm -rf /app
ADD limesurvey3.tar.bz2 /
RUN mv limesurvey app; \
	mkdir -p /uploadstruct; \
	chown -R www-data:www-data /app

RUN cp -r /app/upload/* /uploadstruct ; \
	chown -R www-data:www-data /uploadstruct

RUN chown www-data:www-data /var/lib/php

ADD apache_default /etc/apache2/sites-available/000-default.conf
ADD start.sh /
ADD run.sh /

RUN chmod +x /start.sh && \
    chmod +x /run.sh

VOLUME /app/upload

EXPOSE 80 3306
CMD ["/start.sh"]
