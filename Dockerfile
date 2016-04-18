FROM redmatter/cron

MAINTAINER Dino.Korah@RedMatter.com

ENV TZ="Europe/London" \
	BAMBOO_USER=daemon \
	BAMBOO_GROUP=daemon \
	BAMBOO_BACKUP_HOME=/app/atlassian/bamboo/backup \
	BAMBOO_BACKUP_USER=backup \
	BAMBOO_BACKUP_PASS=letmein \
	BAMBOO_URL=http://bamboo \
	MYSQL_HOST=mysql \
	MYSQL_DATABASE=bamboo \
	MYSQL_USER=atlbamboo \
	MYSQL_PASSWORD=letmein
ENV BAMBOO_BACKUP_LOG=${BAMBOO_BACKUP_HOME}/log/bamboo-backup.log \
    # semantics to work with cron base image
    RUN_USER=${BAMBOO_USER} \
    RUN_GROUP=${BAMBOO_GROUP}

# pull in the bits we need for the build
ADD https://github.com/redmatter/atlassian-bamboo-diy-backup/archive/rename-and-fix-bitbucket-references.zip /tmp/files.zip
COPY bamboo.diy-backup.vars.sh rotate-log.sh /tmp/

RUN ( \
		export DEBIAN_FRONTEND=noninteractive; \
		export BUILD_DEPS="unzip"; \
		export APP_DEPS="tar mysql-client jq rsync curl ca-certificates"; \

		# so that each command can be seen clearly in the build output
		set -e -x; \

		# update and upgrade for vulnerability fixes etc.
		apt-get update; \
		apt-get install --no-install-recommends -y $BUILD_DEPS $APP_DEPS ; \

		mkdir -p ${BAMBOO_BACKUP_HOME} ; \
		cd ${BAMBOO_BACKUP_HOME} ; \

		mkdir -p /bamboo-backups log bin archives tmp tmp/bamboo-db tmp/bamboo-home /var/atlassian/application-data/bamboo ; \
		touch ${BAMBOO_BACKUP_LOG} ; \

		# extract the archive, apply patch and add the config
		unzip -j -d bin /tmp/files.zip ; \
		rm /tmp/files.zip ; \
		mv /tmp/bamboo.diy-backup.vars.sh /tmp/rotate-log.sh bin ; \

        # create user with crontab capability
        cron-user add -u $BAMBOO_USER -g $BAMBOO_GROUP; \

		# set correct permissions
		chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} . /var/atlassian/application-data/bamboo ; \
		chmod -R go-rwx /bamboo-backups log bin tmp archives /var/atlassian/application-data/bamboo ; \

		# remove packages that we don't need
		apt-get remove -y $BUILD_DEPS ; \
		apt-get autoremove -y ; \
		apt-get clean; \
		rm -rf /var/lib/{apt,dpkg,cache,log}/; \
	)

WORKDIR ${BAMBOO_BACKUP_HOME}

VOLUME [ "/bamboo-backups", "${BAMBOO_BACKUP_HOME}/log", "/var/atlassian/application-data/bamboo" ]

USER ${BAMBOO_USER}
