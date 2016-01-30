#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
FROM ubuntu:trusty

# Install Nginx.
RUN \
  apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Script for check update config files in /etc/nginx/conf.d
COPY check_update.sh /etc/cron.d/check_update.sh
RUN chmod 0644 /etc/cron.d/check_update.sh
RUN \
  echo "* * * * * /etc/cron.d/check_update.sh 2>&1 | /usr/bin/logger -t Nginx_config_check" | crontab - && \
  echo -e ':wq' | crontab -e 2>/dev/null

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443

