# docker-bamboo-backup

This is the source of the docker image [`redmatter/bamboo-backup`](https://hub.docker.com/r/redmatter/bamboo-backup/).
It repackages the [Bamboo DIY backup scripts](https://github.com/redmatter/atlassian-bamboo-diy-backup), with basic
settings appropriate for Red Matter. More work needs to be done to make it more generic, to work with other databases
and deployment combinations. In its current shape, it works with MySQL as database and using `rsync` for home directory
backup. Archive formats `tar` and `tar-gpg` are supported.

It also comes with an Amazon&reg; S3 sync client based on `s3cmd` tool. See S3 backup section below for config options.

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

## Amazon&reg; S3 Backup

    AWS_ACCESS_KEY - Access Key
    AWS_SECRET_KEY - Secret Key
    AWS_S3_BUCKET - Bucket name
    AWS_S3_BUCKET_PATH - Optional path within bucket

## GPG Encrypted Backup Archives

If you prefer to create GPG encrypted backup archives, rather than plain tar balls, you need to specify
`BACKUP_ARCHIVE_TYPE=tar-gpg`. The GPG encryptor can be further configured to do either symmetric or asymmetric
encryption by using the variable `GPG_MODE`. For `GPG_MODE=symmetric` you would also need to specify a passphrase using
the variable `GPG_PASSPHRASE`. If you choose `GPG_MODE=asymmetric`, then you will have to specify a GPG key using the
semantics defined in GPG documentation ([`man gpg`](https://www.gnupg.org/gph/de/manual/r1023.html#AEN1789)).

