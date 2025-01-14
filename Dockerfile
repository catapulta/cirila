FROM python:3.6-alpine

# Install required dependencies
RUN apk add --no-cache \
    wget \
    build-base \
    tzdata

# Set timezone
RUN cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    echo "America/Los_Angeles" > /etc/timezone

# Install sucks package
RUN wget -q https://github.com/bmartin5692/sucks/archive/2a2b0c419c2da2af50039e6bf9c027ab291f3938.tar.gz -O sucks.tar.gz && \
    tar xf sucks.tar.gz && \
    cd sucks-2a2b0c419c2da2af50039e6bf9c027ab291f3938 && \
    pip install . && \
    cd .. && \
    rm -rf sucks.tar.gz sucks-2a2b0c419c2da2af50039e6bf9c027ab291f3938

# Configure sucks
RUN sucks login --email cirila@outlook.com --password password --country-code us --continent-code na --verify-ssl False

# Setup cron
COPY cronjob /etc/crontabs/root
RUN chmod 0644 /etc/crontabs/root

CMD ["busybox", "crond", "-f", "-L", "/dev/stdout"]

