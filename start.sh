#!/bin/sh

file="/init_done"
dir=/var/dokuwiki-storage
saved_dirs="data/pages data/meta  data/media  data/media_attic data/media_meta data/attic conf lib/plugins lib/styles lib/tpl"

if [ -f "$file" ]
then
	echo "$file found."

elif [ "$(ls -A $dir)" ]
then
	echo "mounted dir not empty"	

        for saved_dir in $saved_dirs
        do
          rm -r /var/www/$saved_dir
          ln -s /var/dokuwiki-storage/$saved_dir /var/www/$saved_dir
        done

else
	mkdir -p /var/www /var/dokuwiki-storage/data

        for saved_dir in $saved_dirs
        do
           mv /var/www/$saved_dir /var/dokuwiki-storage/$saved_dir
           ln -s /var/dokuwiki-storage/$saved_dir /var/www/$saved_dir
        done

fi
echo "1" > /init_done

set -e

chown -R nobody:nogroup /var/lib/nginx
chown -R nobody:nogroup /var/www
chown -R nobody:nogroup /var/dokuwiki-storage


su -s /bin/sh nobody -c 'php7 /var/www/bin/indexer.php -c'

exec /usr/bin/supervisord -c /etc/supervisord.conf
