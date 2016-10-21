Odoo 10.0
========

This docker image is for Odoo 10.0

After the download process is completed you can run the container with:

    docker run -it -P --restart=always -p 0.0.0.0:32778:8069 -p 0.0.0.0:32777:8072  -p 0.0.0.0:32780:22 -p 0.0.0.0:32779:5432 --name odoo10 -d imageid

REMEMBER:

After your container is built, you have to turn on Postgres Service & SSH Server:

    sudo service postgresql start
    sudo service ssh start
And run Odoo service, with the 2 known options:
     
    sudo service odoo-server start
    sudo /etc/init.d/odoo-server start