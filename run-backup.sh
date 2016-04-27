#!/bin/bash

exec >>/app/atlassian/bamboo/backup/log/bamboo-backup.log
exec 2>&1

# die on failure
set -e

/app/atlassian/bamboo/backup/bin/bamboo.diy-backup.sh
if [ -z "${AWS_ACCESS_KEY}${AWS_SECRET_KEY}" ]; then
    echo "AWS_ACCESS_KEY and AWS_SECRET_KEY not defined; NOT syncing to Amazon S3"
else
    /app/atlassian/bamboo/backup/bin/s3sync.sh
fi

