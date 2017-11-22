Odoo 11.0
========

This docker image is for Odoo 11.0

After the download process is completed you can run the container with:

    docker run -it --restart=always -p 0.0.0.0:32769:8069 -p 0.0.0.0:32770:8072 -p 0.0.0.0:32771:22 -p 0.0.0.0:32768:5432 --name odoo10 -d xluiisx/odoo:odoo10

REMEMBER:

After your container is built, you have to turn on Postgres Service & SSH Server:

    sudo service postgresql start
    OR
    sudo service ssh start
    
And run Odoo service, with the 2 known options:
     
    sudo service odoo-server start
    OR
    sudo /etc/init.d/odoo-server start