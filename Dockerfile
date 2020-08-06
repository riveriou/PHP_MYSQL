FROM ubuntu:latest
MAINTAINER River riou

ENV DEBIAN_FRONTEND noninteractive

RUN ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && echo Asia/Taipei > /etc/timezone
RUN apt-get update --fix-missing
RUN apt-get install -y curl net-tools wget vim nano dialog software-properties-common mysql-server php php-dev php-xml php-mysql php-gd libapache2-mod-php apache2



RUN echo "<?PHP phpinfo(); ?>" >> /var/www/html/test.php

RUN apt-get install -y supervisor
RUN apt-get clean

RUN echo "[supervisord] " >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "user=root" >> /etc/supervisor/conf.d/supervisord.conf

RUN echo '#!/bin/sh' >> /startup.sh
RUN echo 'service apache2 restart' >> /startup.sh
RUN echo 'service mysql restart' >> /startup.sh
RUN echo 'exec supervisord -c /etc/supervisor/supervisord.conf' >> /startup.sh

RUN chmod +x /startup.sh

EXPOSE  80
CMD ["/startup.sh"]
