# docker-bamboo-backup

This is the source of the docker image [`redmatter/bamboo-backup`](https://hub.docker.com/r/redmatter/bamboo-backup/).
It repackages the Bamboo DIY backup scripts, with basic settings appropriate for Red Matter. More work need to be done
to make it more generic, to work with other databases and deployment combinations. In its current shape, it works with
MySQL as database and using `rsync` for home directory backup.

## How to use it?

On its own, it is configured to do daily backups into the volume `/bamboo-backups`. It is designed to be deployed on the
same docker host as the bamboo instance as it needs volume access to the bamboo home directory.

You can run the container using the command below.

    docker run -d --name bamboo-backup \
      -e BAMBOO_BACKUP_USER=bamboo.backup.user \
      -e BAMBOO_BACKUP_PASS=bamboo.backup.user.password \
      -e BAMBOO_URL=http://bamboo.example.com \
      -e BAMBOO_BACKUP_EXCLUDE="logs secret.txt" \
      -e MYSQL_HOST=mysql.example.com \
      -e MYSQL_DATABASE=bamboo \
      -e MYSQL_USER=bamboo \
      -e MYSQL_PASSWORD=database.password \
      redmatter/bamboo-backup

It will then run a cron task that will create backup every midnight. In order to copy the backup archive into a safe
place, you may use the below formula.

    docker run --rm -it --name copy-bamboo-backup \
      --volumes-from bamboo-backup -v /path/to/a-safe-place/:/safe-place \
      busybox cp /bamboo-backups/* /safe-place/.

