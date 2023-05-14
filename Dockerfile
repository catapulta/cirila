FROM python:3.6.13-slim-buster

RUN apt update && apt install -y git vim cron build-essential && apt clean

RUN mkdir sucks && \
    cd sucks && \
    git init && \
    git remote add origin https://github.com/bmartin5692/sucks.git && \
    git fetch origin 2a2b0c419c2da2af50039e6bf9c027ab291f3938 && \
    git reset --hard FETCH_HEAD

RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

RUN cd sucks && pip install -e . --no-binary :all:

RUN sucks login --email aldo.marini@outlook.com --password laaspiradoraloca --country-code us --continent-code na --verify-ssl True

COPY cronjob /etc/cron.d/cron-vacuum

RUN chmod 0644 /etc/cron.d/cron-vacuum

# COPY cronjob /var/spool/cron/crontabs/root

RUN service cron start

RUN crontab /etc/cron.d/cron-vacuum

# RUN touch /var/log/cron-vacuum.log && touch /var/log/cron-time.log

CMD ["cron", "-f"]

