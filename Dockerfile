FROM ubuntu:latest

MAINTAINER HAN

ENV DEBIAN_FRONTEND noninteractive

# Install basics
RUN apt-get update

RUN apt-get install -y software-properties-common && add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y curl

# Install PHP 7.1
RUN apt-get --allow-unauthenticated install  php7.1 php7.1-mysql php7.1-mcrypt php7.1-cli php7.1-gd php7.1-curl php7.1-mbstring php7.1-xml php7.1-zip php-sqlite3 -y

# Enable apache mods.
RUN a2enmod php7.1
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.1/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.1/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80
EXPOSE 8080
EXPOSE 443
#EXPOSE 3306

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND