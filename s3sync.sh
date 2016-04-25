#!/bin/bash

sed -i "s~{{AWS_ACCESS_KEY}}~${AWS_ACCESS_KEY}~g;
    s~{{AWS_SECRET_KEY}}~${AWS_SECRET_KEY}~g;
    s~{{GPG_PASSPHRASE}}~${GPG_PASSPHRASE}~g;" \
        ${BAMBOO_BACKUP_HOME}/s3cfg.ini

${AWS_S3_BUCKET_PATH:=}
if [ -n "${AWS_S3_BUCKET_PATH}" ]; then
    AWS_S3_BUCKET_PATH=$(readlink -m "/${AWS_S3_BUCKET_PATH}/")
fi

exec s3cmd --config=${BAMBOO_BACKUP_HOME}/s3cfg.ini sync /bamboo-backups/ s3://${AWS_S3_BUCKET}${AWS_S3_BUCKET_PATH}/
