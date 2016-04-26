#!/bin/bash

: ${AWS_ACCESS_KEY:?"AWS Access key not specified (AWS_ACCESS_KEY)"}
: ${AWS_SECRET_KEY:?"AWS Secret key not specified (AWS_SECRET_KEY)"}
: ${AWS_S3_BUCKET:?"AWS Bucket name not specified (AWS_S3_BUCKET)"}
: ${AWS_S3_BUCKET_PATH:=}

: ${DEBUG:=0}
[ "$DEBUG" = 1 ] && set -x;

sed -i "s~{{AWS_ACCESS_KEY}}~${AWS_ACCESS_KEY}~g;
    s~{{AWS_SECRET_KEY}}~${AWS_SECRET_KEY}~g;" \
        ${BAMBOO_BACKUP_HOME}/s3cfg.ini

if [ -n "${AWS_S3_BUCKET_PATH}" ]; then
    AWS_S3_BUCKET_PATH=$(readlink -m "/${AWS_S3_BUCKET_PATH}/")
fi

exec s3cmd --config=${BAMBOO_BACKUP_HOME}/s3cfg.ini sync /bamboo-backups/ s3://${AWS_S3_BUCKET}${AWS_S3_BUCKET_PATH}/
