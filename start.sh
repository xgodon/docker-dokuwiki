#!/bin/sh

file="/init_done"
dir=/var/dokuwiki-storage

if [ -f "$file" ]
then
	echo "$file found."

elif [ "$(ls -A $dir)" ]
then
	echo "mounted dir not empty"	
	
	rm /var/www/data/pages
	rm /var/www/data/meta
	rm /var/www/data/media
	rm /var/www/data/media_attic
	rm /var/www/data/media_meta
	rm /var/www/data/attic
	rm /var/www/conf


	ln -s /var/dokuwiki-storage/data/pages /var/www/data/pages && \
	ln -s /var/dokuwiki-storage/data/meta /var/www/data/meta && \
	ln -s /var/dokuwiki-storage/data/media /var/www/data/media && \
	ln -s /var/dokuwiki-storage/data/media_attic /var/www/data/media_attic && \
	ln -s /var/dokuwiki-storage/data/media_meta /var/www/data/media_meta && \
	ln -s /var/dokuwiki-storage/data/attic /var/www/data/attic && \
	ln -s /var/dokuwiki-storage/conf /var/www/conf

else
	mkdir -p /var/www /var/dokuwiki-storage/data

	mv /var/www/data/pages /var/dokuwiki-storage/data/pages && \
	ln -s /var/dokuwiki-storage/data/pages /var/www/data/pages && \
 	mv /var/www/data/meta /var/dokuwiki-storage/data/meta && \
 	ln -s /var/dokuwiki-storage/data/meta /var/www/data/meta && \
 	mv /var/www/data/media /var/dokuwiki-storage/data/media && \
 	ln -s /var/dokuwiki-storage/data/media /var/www/data/media && \
 	mv /var/www/data/media_attic /var/dokuwiki-storage/data/media_attic && \
 	ln -s /var/dokuwiki-storage/data/media_attic /var/www/data/media_attic && \
 	mv /var/www/data/media_meta /var/dokuwiki-storage/data/media_meta && \
 	ln -s /var/dokuwiki-storage/data/media_meta /var/www/data/media_meta && \
 	mv /var/www/data/attic /var/dokuwiki-storage/data/attic && \
 	ln -s /var/dokuwiki-storage/data/attic /var/www/data/attic && \
 	mv /var/www/conf /var/dokuwiki-storage/conf && \
 	ln -s /var/dokuwiki-storage/conf /var/www/conf
	
	
	echo "1" > /init_done
fi

set -e

chown -R nobody /var/lib/nginx
chown -R nobody /var/www
chown -R nobody /var/dokuwiki-storage


su -s /bin/sh nobody -c 'php7 /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf
