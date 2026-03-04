FROM ubuntu:24.04
MAINTAINER Luis Triana <luistriana.28@gmail.com>

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf
RUN apt-get update \
    && apt-get install sudo gnupg language-pack-es -y \
    && locale-gen "en_US.UTF-8" "fr_FR.UTF-8"
ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    PYTHONIOENCODING="UTF-8" TERM="xterm" DEBIAN_FRONTEND="noninteractive"
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
    wget
RUN apt update && \
    apt install -y curl gnupg2 lsb-release apt-transport-https ca-certificates && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
        aptitude \
        build-essential \
        curl \
        python3 \
        python3-dev\
        python3-pip \
        fontconfig \
        git \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        node-less \
        npm \
        nano \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        libsasl2-dev \
        libldap2-dev \
        libssl-dev \
        libfontconfig1 \ 
        libfreetype6 \
        libffi-dev \
        libx11-6 \
        libxext6 \ 
        libxrender1 \
        libmysqlclient-dev \
        libjpeg-dev \
        libpq-dev \
        libjpeg8-dev \
        liblcms2-dev \
        libblas-dev \
        libatlas-base-dev \
        fontconfig \
        xvfb \
        xorg \        
        libfontconfig \
        xfonts-base \
        xfonts-75dpi

# Install wkhtmltopdf
RUN cd /tmp && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
    && dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb && apt --fix-broken install

# Download and install odoo requirements from github.com/odoo/odoo/requirements.txt
RUN cd /tmp &&wget -q https://raw.githubusercontent.com/odoo/odoo/18.0/requirements.txt && \
    pip3 install -r requirements.txt && pip3 install --upgrade pip

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Add ODOO user
RUN adduser --home=/home/odoo-18.0/ --disabled-password --gecos "" --shell=/bin/bash odoo
RUN echo 'root:odoo**' | chpasswd 
RUN echo "odoo ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Create odoo-server.conf
ADD files/odoo-server.conf /home/odoo-18.0/odoo-server.conf
RUN chown odoo /home/odoo-18.0/odoo-server.conf && \
    chmod +x /home/odoo-18.0/odoo-server.conf

#Install Odoo
RUN cd /home/odoo-18.0/ && git clone -b 18.0 --single-branch --depth=1 https://github.com/odoo/odoo.git odoo
RUN chmod +x /home/odoo-18.0/odoo
RUN mkdir -p /home/odoo-18.0/.local/share/Odoo/filestore && \
    chown -R odoo:odoo /home/odoo-18.0/.local/share/Odoo/filestore

#Odoo Log
RUN mkdir -p /home/odoo-18.0/.local/log/Odoo && \
    touch /home/odoo-18.0/.local/log/Odoo/odoo-server.log && \
    chown odoo: -R /home/odoo-18.0/.local/log/Odoo && \
    chmod -R 777 /home/odoo-18.0/.local/log/Odoo/odoo-server.log

RUN mkdir -p /home/odoo-18.0/extra-addons \
        && chown -R odoo:odoo /home/odoo-18.0/extra-addons && \
        chown -R odoo:odoo /home/odoo-18.0/
VOLUME ["/home/odoo-18.0/"]

# Add entrypoint file and give execute permission
ADD files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Correct error with ssl-cert permissions for Postgres
RUN mkdir /etc/ssl/private-copy && \
    mv /etc/ssl/private/* /etc/ssl/private-copy/ && \
    rm -r /etc/ssl/private && \
    mv /etc/ssl/private-copy /etc/ssl/private && \
    chmod -R 0700 /etc/ssl/private && \
    chown -R postgres /etc/ssl/private

USER postgres

# Run Postgres Server
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER odoo WITH SUPERUSER PASSWORD 'odoo';"

USER odoo

CMD /entrypoint.sh

EXPOSE 8069
EXPOSE 8072
EXPOSE 22
EXPOSE 5432