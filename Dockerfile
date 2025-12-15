FROM ubuntu:20.04

LABEL maintainer="tolgatasci1@gmail.com"
LABEL version="1"
LABEL description="It sends traffic using the tor network."

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Kiev

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Base packages
RUN apt-get update && apt-get install -y \
    ca-certificates \
    gnupg2 \
    wget \
    curl \
    unzip \
    xvfb \
    psmisc \
    netcat \
    tor \
    tor-geoipdb \
    torsocks \
    python3 \
    python3-pip \
    chromium-browser \
    chromium-driver \
    && apt-get clean

# Google Chrome (optional but kept for compatibility)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get install -y google-chrome-stable

# Working directory
WORKDIR /scripts

# Python deps
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# App files
COPY entrypoint.sh /scripts/entrypoint.sh
COPY hit.py /scripts/hit.py
COPY refreship.py /scripts/refreship.py
COPY torrc /etc/tor/torrc

RUN chmod +x /scripts/entrypoint.sh

# Start
ENTRYPOINT ["sh", "/scripts/entrypoint.sh"]

# Keep container alive for Railway
CMD ["tail", "-f", "/dev/null"]
