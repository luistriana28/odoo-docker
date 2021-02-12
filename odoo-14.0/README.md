Odoo 13.0
========

This docker image is for Odoo 13.0

After the download process is completed you can run the container with:

    docker run --restart=always -p 32769:8069 -p 32770:8072  -p 32771:22 -p 32772:5432 --name odoo13 -d xluiisx/odoo:13.0
