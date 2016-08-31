Odoo Dockerfiles for Containers
========

This docker image is for Odoo 9.0 && Openerp 7

After the download process is completed you can run the container:

    You can install any other dependency or app.

    You can clone any other module from github, just remember to add it
    on the odoo-server.conf 

REMEMBER:

After your container is built, you have to turn on Postgres Service & SSH Server:

    sudo service postgresql start
    sudo service ssh start