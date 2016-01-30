#!/bin/bash
CONF_DIR='/etc/nginx/conf.d/'
if find ${CONF_DIR}*.conf -mmin -1 | grep -q conf; 
	then 
		/etc/init.d/nginx configtest 2>&1 | grep -q "done" && /etc/init.d/nginx reload || echo "WARNING: NGINX CONFIG FAILED"
fi
