FROM php:7.3-fpm

# Install deps
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
  cron

# Setup cron
# Ref: https://gist.github.com/mowings/59790ae930accef486bfb9a417e9d446
COPY crontabs /etc/crontab

CMD cron -f
