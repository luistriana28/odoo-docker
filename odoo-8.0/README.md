Odoo 9.0
========

This docker image is for Odoo 9.0

After the download process is completed you can run the container with:

    docker run -it -P --restart=always -p 0.0.0.0:32800:8069 -p 0.0.0.0:32801:8072  -p 0.0.0.0:32802:22 -p 0.0.0.0:32803:5432 --name odoo9 -d imageid

REMEMBER:

After your container is built, you have to turn on Postgres Service & SSH Server:

    sudo service postgresql start
    sudo service ssh start