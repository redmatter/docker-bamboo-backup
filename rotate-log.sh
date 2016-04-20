#!/bin/sh

/bin/gzip -c ${BAMBOO_BACKUP_LOG} > ${BAMBOO_BACKUP_LOG}.$(date +%Y%m%d).gz &&
	cat /dev/null > ${BAMBOO_BACKUP_LOG}
