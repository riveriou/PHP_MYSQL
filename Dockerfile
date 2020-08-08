FROM ubuntu:latest
MAINTAINER River riou

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && echo Asia/Taipei > /etc/timezone
RUN apt-get update --fix-missing
RUN apt-get install -y curl wget vim nano lsof net-tools dialog less unzip software-properties-common

RUN add-apt-repository ppa:ondrej/php
RUN apt update

RUN apt-get install -y mariadb-server php5.6 php5.6-dev php5.6-xml php5.6-mysql php5.6-gd libapache2-mod-php5.6 apache2 --no-install-recommends



RUN echo "<?PHP phpinfo(); ?>" >> /var/www/html/test.php

RUN apt-get install -y supervisor

RUN echo "[supervisord] " >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "user=root" >> /etc/supervisor/conf.d/supervisord.conf

RUN echo '#!/bin/sh' >> /startup.sh
RUN echo 'service apache2 start' >> /startup.sh
RUN echo 'service mysql start' >> /startup.sh
RUN echo 'exec supervisord -c /etc/supervisor/supervisord.conf' >> /startup.sh

RUN chmod +x /startup.sh

RUN apt-get clean

EXPOSE  80
CMD ["/startup.sh"]
