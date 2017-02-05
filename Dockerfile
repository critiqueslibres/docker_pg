FROM centos:latest
MAINTAINER ptim007@yahoo.com
ENV MAJORVER=9
ENV MINORVER=6
RUN yum update -y
RUN yum install -y libxslt systemd-sysv
ADD https://yum.postgresql.org/${MAJORVER}.${MINORVER}/redhat/rhel-7-x86_64/postgresql${MAJORVER}${MINORVER}-${MAJORVER}.${MINORVER}.1-1PGDG.rhel7.x86_64.rpm /tmp
ADD https://yum.postgresql.org/${MAJORVER}.${MINORVER}/redhat/rhel-7-x86_64/postgresql${MAJORVER}${MINORVER}-contrib-${MAJORVER}.${MINORVER}.1-1PGDG.rhel7.x86_64.rpm /tmp
ADD https://yum.postgresql.org/${MAJORVER}.${MINORVER}/redhat/rhel-7-x86_64/postgresql${MAJORVER}${MINORVER}-libs-${MAJORVER}.${MINORVER}.1-1PGDG.rhel7.x86_64.rpm /tmp
ADD https://yum.postgresql.org/${MAJORVER}.${MINORVER}/redhat/rhel-7-x86_64/postgresql${MAJORVER}${MINORVER}-server-${MAJORVER}.${MINORVER}.1-1PGDG.rhel7.x86_64.rpm /tmp
RUN rpm -i /tmp/postgresql${MAJORVER}${MINORVER}-${MAJORVER}.${MINORVER}.1-1PGDG.rhel7.x86_64.rpm \
           /tmp/postgresql${MAJORVER}${MINORVER}-contrib-${MAJORVER}.${MINORVER}.1-1PGDG.rhel7.x86_64.rpm \
           /tmp/postgresql${MAJORVER}${MINORVER}-libs-${MAJORVER}.${MINORVER}.1-1PGDG.rhel7.x86_64.rpm \
           /tmp/postgresql${MAJORVER}${MINORVER}-server-${MAJORVER}.${MINORVER}.1-1PGDG.rhel7.x86_64.rpm 
RUN mkdir -p /u01/pg96/data /u02/backup /u02/archive && chown -R postgres:postgres /u01/pg96 /u02/backup /u02/archive && chmod 700 /u01/pg96/data /u02/archive
ENV PGDATA /u01/pg96/data
ENV LANG=en_US.UTF-8
RUN usermod -G wheel -a postgres && echo "postgres" | passwd --stdin postgres
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
USER postgres
#RUN /usr/pgsql-9.6/bin/pg_ctl initdb -D ${PGDATA} -o "--encoding='UTF8' --locale=C"
#RUN /usr/pgsql-9.6/bin/pg_ctl -D /u01/pg96/data start -w && \
#      /usr/pgsql-9.6/bin/psql --command "create database phoenix ENCODING='UTF8' LC_COLLATE='C';"
ADD initdb.sh /tmp
RUN /tmp/initdb.sh
VOLUME ["/u01/pg96/data","/u02/archive"]
ENTRYPOINT ["/usr/pgsql-9.6/bin/pg_ctl","-D","${PGDATA}","start"]
