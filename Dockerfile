FROM ubuntu:latest
MAINTAINER Selau Eleven <selau@eleven.io>

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
RUN apt-get update && \
  apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 php7.2 php7.2-mysql libapache2-mod-php7.2 curl

# Enable apache mods.
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.2/apache2/php.ini && \
 sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.2/apache2/php.ini && \
 sed -i 's/80/8080/g' /etc/apache2/ports.conf && \
 chgrp -R 0 /var/log/apache2 && \
 chmod -R g=u /var/log/apache2 && \
 chgrp -R 0 /var/run/apache2 && \
 chmod -R g=u /var/run/apache2

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
 ln -sf /dev/stderr /var/log/apache2/error.log

# Expose apache.
EXPOSE 8080

# Copy this repo into place.
ADD app /var/www/site

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
