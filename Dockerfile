FROM ubuntu:22.04

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

WORKDIR /app
COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY main.py .
ENV FLASK_APP main
ENV FLASK_ENV production

EXPOSE 5000
CMD ["flask", "run", "-h", "0.0.0.0"]