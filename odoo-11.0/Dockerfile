FROM ubuntu:14.04
MAINTAINER Luis Triana <luis.triana@jarsa.com.mx>

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
    && echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf
RUN apt-get update \
    && apt-get install language-pack-es -y \
    && locale-gen "en_US.UTF-8" "fr_FR.UTF-8"
ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    PYTHONIOENCODING="UTF-8" TERM="xterm" DEBIAN_FRONTEND="noninteractive"
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
    wget
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' >> /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
RUN apt-get update -q && apt-get upgrade -q && \
    apt-get install --allow-unauthenticated -q \
    aptitude \
    build-essential \
    curl \
    fontconfig \
    gdebi-core \
    git \
    libevent-dev \
    libffi-dev \
    libjpeg-dev \
    libldap2-dev \
    libpq-dev \
    libsasl2-dev \
    libssl-dev \
    libx11-6 \
    libxext6 \
    libxml2-dev \
    libxrender1 \
    libxslt-dev \
    nano \
    node-less \
    nodejs \
    npm \
    openssh-server \
    openssl \
    postgresql-9.5 \
    postgresql-client-9.5 \
    postgresql-contrib-9.5 \
    postgresql-server-dev-9.5 \
    python3 \
    python3-pip \
    swig \
    xfonts-75dpi \
    xfonts-base \
    xmlstarlet \
    xsltproc \
    xz-utils

# Install wkhtmltopdf
RUN cd /tmp && \
    curl -o wkhtmltox.tar.xz -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && tar xvf wkhtmltox.tar.xz \
    && cp wkhtmltox/lib/* /usr/local/lib/ \
    && cp wkhtmltox/bin/* /usr/local/bin/ \
    && cp -r wkhtmltox/share/man/man1 /usr/local/share/man/

# Download and install odoo requirements from github.com/odoo/odoo/requirements.txt
RUN cd /tmp && \
    wget -q https://raw.githubusercontent.com/luistriana28/odoo/11.0/requirements.txt && \
    pip3 install -r requirements.txt && pip3 install --upgrade pip

#Python Libraries
RUN apt-get install python-dateutil \
    python-decorator \
    python-docutils \
    python-feedparser \
    python-jinja2 \
    python-ldap \
    python-libxslt1 \
    python-lxml \
    python-mako \
    python-mock \
    python-openid \
    python-passlib \
    python-pil \
    python-pip \
    python-psutil \
    python-psycopg2 \
    python-pybabel \
    python-pychart \
    python-pydot \
    python-pyparsing \
    python-pypdf \
    python-reportlab \
    python-requests \
    python-simplejson \
    python-tz \
    python-unittest2 \
    python-vatnumber \
    python-vobject \
    python-webdav \
    python-werkzeug \
    python-xlwt \
    python-yaml \
    python-zsi \
    python3-dev \
    python3-imaging \
    python3-openssl \
    python3-pandas \
    python3-psycopg2 \
    python3-renderpm \
    python3-setuptools 


#Python3 Libraries
RUN pip3 install decorator \
    docutils \
    gdata \
    html2text \
    lxml \
    ninja2 \
    passlib \
    phonenumbers \
    psutil \
    psycopg2 \
    pypdf2 \
    pyyaml \
    reportlab \
    requests \
    Werkzeug 

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Add ODOO user
RUN adduser --home=/home/odoo-11.0/ --disabled-password --gecos "" --shell=/bin/bash odoo
RUN echo 'root:odoo**' | chpasswd 
RUN echo "odoo ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Create odoo-server.conf
ADD files/odoo-server.conf /home/odoo-11.0/odoo-server.conf
RUN chown odoo /home/odoo-11.0/odoo-server.conf && \
    chmod +x /home/odoo-11.0/odoo-server.conf

# Create odoo-server service
ADD files/odoo-server /etc/init.d/odoo-server
RUN chown odoo /etc/init.d/odoo-server && \
    chmod +x /etc/init.d/odoo-server

#Install Odoo
RUN cd /home/odoo-11.0/ && git clone -b 11.0 --single-branch --depth=1 https://github.com/odoo/odoo.git odoo
RUN chown -R odoo:odoo /home/ && chmod +x /home/odoo-11.0/odoo

USER postgres

# Run Postgres Server
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER odoo WITH SUPERUSER PASSWORD 'odoo';"

USER odoo

CMD /bin/bash

EXPOSE 8069
EXPOSE 8072
EXPOSE 22
EXPOSE 5432
