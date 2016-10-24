Odoo Dockerfiles for Containers
========

This docker image is for Odoo 8.0, 9.0, 10.0 && Openerp 7

After the download process is completed you can run the container:

    You can install any other dependency or app.

    This is a fresh container with Odoo basic functions.

    You can clone any other module from github, just remember to add it
    on the odoo-server.conf 

REMEMBER:

After your container is built, you have to turn on Postgres Service & SSH Server:

    sudo service postgresql start
    sudo service ssh start

If there is an error when you try to start Postgresql about ssl-cert permissions,
here is an option where you can solve it!
You should be in root user:

    mkdir /etc/ssl/private-copy
    mv /etc/ssl/private/* /etc/ssl/private-copy/
    rm -r /etc/ssl/private
    mv /etc/ssl/private-copy /etc/ssl/private
    chmod -R 0700 /etc/ssl/private
    chown -R postgres /etc/ssl/private
