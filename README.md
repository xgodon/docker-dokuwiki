nerka/docker-dokuwiki
==================


Docker container image with [DokuWiki](https://www.dokuwiki.org/dokuwiki) and nginx

Dokuwiki v. 2017-02-19a "Frusterick Manners"

### available tags

alpine_edge_simple_1.2 ( == latest )

alpine_edge_plugins_1.2

debian_8.7_1.1 (not working atm)

plugin version is simple version with  dw2pdf, bookcreator, smtp, text, odt, and indexmenu plugins.

### How to run

Assume your docker host is localhost and HTTP public port is 8000 (change these values if you need).

First, run new dokuwiki container:

    docker run -d -p 8000:80 --name dokuwiki nerka/docker-dokuwiki:latest

Then setup dokuwiki using installer at URL `http://localhost:8000/install.php`

### How to make data persistent

    docker run -d \
    -p 8000:80 \
    --name dokuwiki \
    -v /home/docker/wiki/dokuwiki-storage:/var/dokuwiki-storage \
    nerka/docker-dokuwiki:latest
    
    Note: only these folders are backed up:

    data/pages/
    data/meta/
    data/media/
    data/media_attic/
    data/media_meta/
    data/attic/
    conf/

On the container launch, the start.sh script check if there are files in /var/dokuwiki-storage.
if there is , they are used.


### Persistent plugins

Dokuwiki installs plugins to `lib/plugins/`, but this folder isn't inside persistent volume storage by default, so all plugins will be erased when container is re-created.  The recommended way to make plugins persistent is to create your own Docker image with this image as a base image and use shell commands inside the Dockerfile to install needed plugins.

You can also edit the start.sh and put the lib/plugin directory in the dokuwiki-storage dir



