FROM ubuntu:20.04
MAINTAINER Luis Triana <luis.triana@jarsa.com.mx>

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf
RUN apt-get update \
    && apt-get install sudo gnupg language-pack-es -y \
    && locale-gen "en_US.UTF-8" "fr_FR.UTF-8"
ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    PYTHONIOENCODING="UTF-8" TERM="xterm" DEBIAN_FRONTEND="noninteractive"
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
    wget
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' >> /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
RUN echo 'deb http://security.ubuntu.com/ubuntu xenial-security main' >> /etc/apt/sources.list
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
        aptitude \
        build-essential \
        curl \
        python3 \
        python-dev \
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
        python3-openssl \
        openssh-server \
        openssl \
        python3-num2words \
        python3-pdfminer \
        python3-pip \
        python3-phonenumbers \
        python3-pyldap \
        python3-qrcode \
        python3-renderpm \
        python3-setuptools \
        python3-slugify \
        python3-vobject \
        python3-watchdog \
        python3-xlrd \
        python3-xlwt \
        xz-utils \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        libsasl2-dev \
        libldap2-dev \
        libssl-dev \
        libffi-dev \
        libmysqlclient-dev \
        libjpeg-dev \
        libjpeg8-dev \
        liblcms2-dev \
        libblas-dev \
        libatlas-base-dev \
        postgresql-12 \
        postgresql-client-12 \
        postgresql-contrib-12 \
        postgresql-server-dev-12 \
        swig \
        xmlstarlet \
        xsltproc \
        xz-utils \
        libpq-dev \
        python3-setuptools \
        python3-wheel \
        xfonts-75dpi \
        xfonts-base

# Install wkhtmltopdf
RUN cd /tmp && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
    && dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb

# Download and install odoo requirements from github.com/odoo/odoo/requirements.txt
RUN cd /tmp && \
    wget -q https://raw.githubusercontent.com/odoo/odoo/15.0/requirements.txt && \
    pip3 install -r requirements.txt && pip3 install --upgrade pip

#Python Libraries
RUN pip3 install vobject qrcode pyldap num2words 

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Add ODOO user
RUN adduser --home=/home/odoo-15.0/ --disabled-password --gecos "" --shell=/bin/bash odoo
RUN echo 'root:odoo**' | chpasswd 
RUN echo "odoo ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Create odoo-server.conf
ADD files/odoo-server.conf /home/odoo-15.0/odoo-server.conf
RUN chown odoo /home/odoo-15.0/odoo-server.conf && \
    chmod +x /home/odoo-15.0/odoo-server.conf

#Install Odoo
RUN cd /home/odoo-15.0/ && git clone -b 15.0 --single-branch --depth=1 https://github.com/odoo/odoo.git odoo
RUN chmod +x /home/odoo-15.0/odoo
RUN mkdir -p /home/odoo-15.0/.local/share/Odoo/filestore && \
    chown -R odoo:odoo /home/odoo-15.0/.local/share/Odoo/filestore

#Odoo Log
RUN mkdir -p /home/odoo-15.0/.local/log/Odoo && \
    touch /home/odoo-15.0/.local/log/Odoo/odoo-server.log && \
    chown odoo: -R /home/odoo-15.0/.local/log/Odoo && \
    chmod -R 777 /home/odoo-15.0/.local/log/Odoo/odoo-server.log

RUN mkdir -p /home/odoo-15.0/extra-addons \
        && chown -R odoo:odoo /home/odoo-15.0/extra-addons && \
        chown -R odoo:odoo /home/odoo-15.0/
VOLUME ["/home/odoo-15.0/"]

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