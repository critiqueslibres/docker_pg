#!/bin/bash

PATH=$PATH:/usr/pgsql-9.6/bin

if [ ! -f ${PGDATA}/postgresql.conf ] ; then
  pg_ctl initdb -D ${PGDATA} -o "--encoding='UTF8' --locale=C"
  pg_ctl -D ${PGDATA} start -w 
  psql --command "create database critlib ENCODING='UTF8' LC_COLLATE='C';"
  psql --dbname critlib <<-EOF
	create user critlib_owner with login password 'critlib_owner';
	create schema authorization critlib_owner;
	create user critlib_user with login password 'critlib_user';
	grant usage on schema critlib_owner to critlib_user;
	grant select,insert,update,delete on all tables in schema critlib_owner to critlib_user;
	\q
EOF
fi
