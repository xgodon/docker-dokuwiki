FROM debian:8.7
MAINTAINER Xavier Godon <xav.godon@gmail.com>

#ENV DOKUWIKI_VERSION 2016-06-26a
ENV DOKUWIKI_VERSION 2017-02-19a

ENV MD5_CHECKSUM 9b9ad79421a1bdad9c133e859140f3f2


#RUN apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ add  php7 php7-fpm php7-gd php7-openssl php7-session php7-xml php7-zlib nginx supervisor curl tar
#RUN apk --no-cache  add  php7 php7-fpm php7-gd php7-openssl php7-session php7-xml php7-zlib nginx supervisor curl tar



RUN apt-get update && apt-get install -y wget && \
    echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list && \
    echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list && \
    wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add -



RUN  apt-get update && \
     apt-get install -y libapache2-mod-php7.0 php-pear php7.0 php7.0-cgi php7.0-cli php7.0-common php7.0-fpm php7.0-gd php7.0-json php7.0-mysql php7.0-readline nginx supervisor curl tar && \
     apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /run/nginx && \
    cd /var/www && \
    curl -O -L "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    tar -xzf "dokuwiki-$DOKUWIKI_VERSION.tgz" --strip 1 && \
    rm "dokuwiki-$DOKUWIKI_VERSION.tgz" 

ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /start.sh


EXPOSE 80
VOLUME ["/var/dokuwiki-storage"]

CMD /start.sh
