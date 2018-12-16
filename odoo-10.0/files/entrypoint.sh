#!/bin/bash

sudo service postgresql start

/home/odoo-10.0/odoo/odoo-bin \
-c /home/odoo-10.0/odoo-server.conf

exec "$@"