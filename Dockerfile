FROM ubuntu:22.04


RUN groupadd -r address_parser && useradd -r -g address_parser -s /bin/bash -m -d /home/address_parser address_parser

RUN apt-get update -y && apt-get install -y git python3 python3-pip curl autoconf automake libtool python3-dev pkg-config

RUN git clone https://github.com/openvenues/libpostal /libpostal && \
    cd /libpostal && \
    ./bootstrap.sh && \
    ./configure --datadir=/opt/libpostal && \
    make && \
    make install && \
    ldconfig

RUN git clone https://github.com/openvenues/pypostal.git /pypostal && \
    pip3 install -e /pypostal

COPY --chown=address_parser:address_parser requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

EXPOSE 5000

WORKDIR /home/address_parser/app
COPY --chown=address_parser:address_parser app /home/address_parser/app
COPY --chown=address_parser:address_parser uwsgi.yaml /home/address_parser/uwsgi.yaml

USER address_parser
WORKDIR /home/address_parser
CMD uwsgi --yaml /home/address_parser/uwsgi.yaml
