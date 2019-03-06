#!/bin/bash

sudo service postgresql start

/home/odoo-8.0/odoo/odoo.py \
-c /home/odoo-8.0/odoo-server.conf

exec "$@"