#!/bin/bash
###########
#
# @Author: nardellu@innovyou.co
# From env to odoo config file
#
###########
ODOO_CONFIG_FILE="odoo.conf"

cp -rf base001.conf $ODOO_CONFIG_FILE;

for env_var in $(env); do
	if [[ "$env_var" == *"HOST="* ]]; then
		if [[ ${env_var} != *"TRAEFIK"* ]]; then
			echo "db_host = ${env_var#*=}" >> $ODOO_CONFIG_FILE;
		fi
	fi
done

base002_text=$(cat base002.conf);

echo "$base002_text" >> $ODOO_CONFIG_FILE;

