nerka/docker-dokuwiki
==================


Docker container image with [DokuWiki](https://www.dokuwiki.org/dokuwiki) and nginx
Dokuwiki v. 2017-02-19a "Frusterick Manners"

### todo

be able to mount via -v 

### How to run

Assume your docker host is localhost and HTTP public port is 8000 (change these values if you need).

First, run new dokuwiki container:

    docker run -d -p 8000:80 --name dokuwiki nerka/docker-dokuwiki:1.0

Then setup dokuwiki using installer at URL `http://localhost:8000/install.php`

### How to make data persistent

docker run -d -p 8000:80 --name dokuwiki  istepanov/dokuwiki:2.0

docker inspect dokuwiki

sudo cp -pr "/var/lib/docker/volumes/151c4dadec207608a13145b5e17f936e6cc4f516966fbc57d29ac39be24a425e/_data" /home/docker/wiki/dokuwiki-storage

docker run -it -p 8000:80 --name dokuwiki -v /home/docker/wiki/dokuwiki-storage:/var/dokuwiki-storage istepanov/dokuwiki:2.0


### Persistent plugins

Dokuwiki installs plugins to `lib/plugins/`, but this folder isn't inside persistent volume storage by default, so all plugins will be erased when container is re-created.  The recommended way to make plugins persistent is to create your own Docker image with this image as a base image and use shell commands inside the Dockerfile to install needed plugins.


### How to backup data

    # create dokuwiki-backup.tar.gz archive in current directory using temporaty container
    docker run --rm --volumes-from dokuwiki -v $(pwd):/backup ubuntu tar zcvf /backup/dokuwiki-backup.tar.gz /var/dokuwiki-storage

**Note:** only these folders are backed up:

* `data/pages/`
* `data/meta/`
* `data/media/`
* `data/media_attic/`
* `data/media_meta/`
* `data/attic/`
* `conf/`

### How to restore from backup

    #create new dokuwiki container, but don't start it yet
    docker create -p 8000:80 --name dokuwiki istepanov/dokuwiki:2.0

    # create data container for persistency (optional)
    docker run --volumes-from dokuwiki --name dokuwiki-data busybox

    # restore from backup using temporary container
    docker run --rm --volumes-from dokuwiki -w / -v $(pwd):/backup ubuntu tar xzvf /backup/dokuwiki-backup.tar.gz

    # start dokuwiki
    docker start dokuwiki
