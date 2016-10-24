Odoo 7.0
========

This docker image is for Odoo 7.0

After the download process is completed you can run the container with:

    docker run -it -P --restart=always -p 0.0.0.0:32769:8069 -p 0.0.0.0:32770:8072  -p 0.0.0.0:32771:22 --name odoo7 -d imageid

REMEMBER:

After your container is built, you have to turn on Postgres Service & SSH Server:

    sudo service postgresql start
    sudo service ssh start