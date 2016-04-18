#!/bin/bash

# catch use of undefined variables
set -u

: ${BAMBOO_BACKUP_BASE:=/app/atlassian/bamboo/backup}

##
# It is recomended to `chmod 600 bamboo.diy-backup.vars.sh` after copying the template.
##

CURL_OPTIONS="-L -s -f"

# Which database backup script to use (ex: mssql, postgresql, mysql, ebs-collocated, rds)
BACKUP_DATABASE_TYPE=mysql

# Which filesystem backup script to use (ex: rsync, ebs-home)
BACKUP_HOME_TYPE=rsync

# Which archive backup script to use (ex: tar, tar-gpg)
BACKUP_ARCHIVE_TYPE=tar

# Used by the scripts for verbose logging. If not true only errors will be shown.
BAMBOO_VERBOSE_BACKUP=TRUE

# The base url used to access this bamboo instance. It cannot end on a '/'
# BAMBOO_URL=${BAMBOO_URL}

# Used in AWS backup / restore to tag snapshots. It cannot contain spaces and it must be under 100 characters long
INSTANCE_NAME=bamboo

# The username and password for the user used to make backups (and have this permission)
# BAMBOO_BACKUP_USER=${BAMBOO_BACKUP_USER}
# BAMBOO_BACKUP_PASS=${BAMBOO_BACKUP_PASS}

# The name of the database used by this instance.
BAMBOO_DB=${MYSQL_DATABASE}
# The path to bamboo home folder (with trailing /)
BAMBOO_HOME=/var/atlassian/application-data/bamboo/

# OS level user and group information (typically: 'atlbamboo' for both)
BAMBOO_UID=${BAMBOO_USER}
BAMBOO_GID=${BAMBOO_GROUP}

# The path to working folder for the backup
BAMBOO_BACKUP_ROOT=${BAMBOO_BACKUP_BASE}/tmp
BAMBOO_BACKUP_DB=${BAMBOO_BACKUP_ROOT}/bamboo-db/
BAMBOO_BACKUP_HOME=${BAMBOO_BACKUP_ROOT}/bamboo-home/

# The path to where the backup archives are stored
BAMBOO_BACKUP_ARCHIVE_ROOT=/bamboo-backups

# Space delimited list of files and folders to exclude from $BAMBOO_HOME
# For advanced uses, use RSYNC_EXCLUDE variable
# example BAMBOO_BACKUP_EXCLUDE="secret.txt temp"
#
# BAMBOO_BACKUP_EXCLUDE=${BAMBOO_BACKUP_EXCLUDE}

# PostgreSQL options
POSTGRES_HOST=
POSTGRES_USERNAME=
POSTGRES_PASSWORD=
POSTGRES_PORT=5432

# MySQL options
# MYSQL_HOST=${MYSQL_HOST}
MYSQL_USERNAME=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}
MYSQL_BACKUP_OPTIONS=

# HipChat options
HIPCHAT_URL=https://api.hipchat.com
HIPCHAT_ROOM=
HIPCHAT_TOKEN=

# Options for the tar-gpg archive type
BAMBOO_BACKUP_GPG_RECIPIENT=
