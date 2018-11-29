#!/bin/bash

sudo service postgresql start

/home/odoo-11.0/odoo/odoo-bin \
-c /home/odoo-11.0/odoo-server.conf

exec "$@"