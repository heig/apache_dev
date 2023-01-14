FROM ubuntu:latest

LABEL version="1.1"

MAINTAINER HAN

ENV DEBIAN_FRONTEND noninteractive

# Install basics
RUN apt-get update

RUN apt-get install -y software-properties-common && add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y curl

# Install PHP 8.2
RUN apt-get --allow-unauthenticated install  php8.2 php8.2-mysql php8.2-mcrypt php8.2-cli php8.2-gd php8.2-curl php8.2-mbstring php8.2-xml php8.2-zip php-sqlite3 -y

# Enable apache mods.
RUN a2enmod php8.2
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/8.2/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/8.2/apache2/php.ini

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