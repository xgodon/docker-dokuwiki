#!/bin/sh

file="/init_done"
if [ -f "$file" ]
then
	echo "$file found."
else
	ln /var/www/data/pages /var/dokuwiki-storage/data/pages
	ln /var/www/data/meta /var/dokuwiki-storage/data/meta
	ln /var/www/data/media /var/dokuwiki-storage/data/media
	ln /var/www/data/media_attic /var/dokuwiki-storage/data/media_attic
	ln /var/www/data/media_meta /var/dokuwiki-storage/data/media_meta
	ln /var/www/data/attic /var/dokuwiki-storage/data/attic
	ln /var/www/conf /var/dokuwiki-storage/conf
	
	echo "1" > /init_done
fi

set -e

chown -R nobody /var/lib/nginx
chown -R nobody /var/www
chown -R nobody /var/dokuwiki-storage


su -s /bin/sh nobody -c 'php7 /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf
