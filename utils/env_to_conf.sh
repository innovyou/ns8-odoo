#!/bin/bash
###########
#
# @Author: nardellu@innovyou.co
# @Version: 1.0.0
# @Description: From env vars to odoo config file
###########


ODOO_CONFIG_FILE="odoo.conf"

read -d '' BASE << EOF
[options]
addons_path = /mnt/extra-addons
data_dir = /var/lib/odoo
csv_internal_sep = ,
dbfilter = 
demo = {}
email_from = False
from_filter = False
geoip_database = /usr/share/GeoIP/GeoLite2-City.mmdb
http_enable = True
http_interface = 
import_partial = 
limit_request = 65536
limit_time_cpu = 36000
limit_time_real = 72000
limit_time_real_cron = -1
log_db = False
log_db_level = warning
log_handler = :INFO
log_level = info
logfile = /var/log/odoo/server.log
max_cron_threads = 2
osv_memory_age_limit = False
osv_memory_count_limit = 0
pg_path = 
pidfile = 
reportgz = False
screencasts = 
screenshots = /tmp/odoo_tests
server_wide_modules = base,web
smtp_password = False
smtp_port = 25
smtp_server = localhost
smtp_ssl = False
smtp_ssl_certificate_filename = False
smtp_ssl_private_key_filename = False
smtp_user = False
syslog = False
test_enable = False
test_file = 
test_tags = None
transient_age_limit = 1.0
translate_modules = ['all']
unaccent = False
upgrade_path = 
websocket_keep_alive_timeout = 3600
websocket_rate_limit_burst = 10
websocket_rate_limit_delay = 0.2
x_sendfile = False

EOF

echo "$BASE" > $ODOO_CONFIG_FILE;

env | while IFS= read -r line; do
        value=${line#*=}
        name=${line%%=*}

        # Db
        if [[ "$name" == "ODOO_POSTGRES_HOST" ]]; then
                echo "db_host = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_POSTGRES_MAXCONN" ]]; then
                echo "db_maxconn = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_POSTGRES_PASSWORD" ]]; then
                echo "db_password = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_POSTGRES_PORT" ]]; then
                echo "db_port = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_POSTGRES_SSLMODE" ]]; then
                echo "db_sslmode = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_POSTGRES_SSLMODE" ]]; then
                echo "db_sslmode = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_POSTGRES_TEMPLATE" ]]; then
                echo "db_template = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_POSTGRES_USER" ]]; then
                echo "db_user = $value" >> $ODOO_CONFIG_FILE;
        fi
        

        # Web
        if [[ "$name" == "ODOO_GEVENT_PORT" ]]; then
                echo "gevent_port = $value" >> $ODOO_CONFIG_FILE;
        fi
        
        if [[ "$name" == "ODOO_HTTP_PORT" ]]; then
                echo "http_port = $value" >> $ODOO_CONFIG_FILE;
        fi
        
        if [[ "$name" == "ODOO_PROXY_MODE" ]]; then
                echo "proxy_mode = $value" >> $ODOO_CONFIG_FILE;
        fi


        # Workers
        if [[ "$name" == "ODOO_WORKERS" ]]; then
                echo "workers = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_LIMIT_MEMORYHARD" ]]; then
                echo "limit_memory_hard = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_LIMIT_MEMORYSOFT" ]]; then
                echo "limit_memory_soft = $value" >> $ODOO_CONFIG_FILE;
        fi

        # General
        if [[ "$name" == "ODOO_LISTDB" ]]; then
                echo "list_db = $value" >> $ODOO_CONFIG_FILE;
        fi

        if [[ "$name" == "ODOO_WITHOUTDEMO" ]]; then
                echo "without_demo = $value" >> $ODOO_CONFIG_FILE;
        fi        

done