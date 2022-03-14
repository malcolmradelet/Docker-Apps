# syntax=docker/dockerfile:1
FROM alpine:latest

EXPOSE 80

# TODO
# WORKDIR /tmp

ENV SESSION_LOCATION="/session" \
    TIMEZONE="America/Vancouver" \
    PHP_MAX_UPLOAD="16M" \
    PHP_MAX_POST="32M" \
    PHP_MEMORY_LIMIT="256M" \
    PHP_FPM_USER="apache" \
    PHP_FPM_GROUP="apache" \
    PHP_FPM_LISTEN_MODE="0660"

# Install Apache, PHP and utils from APK
RUN apk add --update --no-cache \
    apache2 \
    apache2-proxy \
    curl \
    graphviz \
    php7-apache2 \
    php7-apcu \
    php7-cli \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-ldap \
    php7-mbstring \
    php7-mysqli \
    php7-phar \
    php7-session \
    php7-simplexml \
    php7-soap \
    php7-tokenizer \
    php7-xml \
    php7-zip \
    tzdata \
    unzip

# Install the latest iTop
RUN curl -fsSL https://sourceforge.net/projects/itop/files/latest/download -o /tmp/iTop.zip && \
    unzip /tmp/iTop.zip -d /tmp && \
    mv /tmp/web/* /var/www/localhost/htdocs && \
    rm /var/www/localhost/htdocs/index.html && \
    rm -rf /tmp/* && \
    mkdir /var/www/localhost/htdocs/env-production

# Install Composer
RUN curl -fsS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# iTop needs a location to save session data. The default is /tmp
# By default, this line merely avoids the warning message during the iTop setup wizard
#
# If you want to persist session data, this location needs to be a docker volume
RUN sed -i 's/;session.save_path = "\/tmp"/session.save_path = ${SESSION_LOCATION}/' /etc/php7/php.ini && \
    mkdir -p ${SESSION_LOCATION} && \
    chown -R apache:apache /var/www/localhost/htdocs && \
    chown -R apache:apache ${SESSION_LOCATION}

# Other tweaks
RUN sed -i 's|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i' /etc/php7/php.ini && \
    sed -i 's|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i' /etc/php7/php.ini && \
    sed -i 's|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i' /etc/php7/php.ini && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo '${TIMEZONE}' > /etc/timezone && \
    sed -i 's|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i' /etc/php7/php.ini && \
    sed -i 's|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g' /etc/php7/php-fpm.d/www.conf && \
    sed -i 's|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g' /etc/php7/php-fpm.d/www.conf && \
    sed -i 's|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g' /etc/php7/php-fpm.d/www.conf && \
    sed -i 's|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g' /etc/php7/php-fpm.d/www.conf && \
    sed -i 's|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g' /etc/php7/php-fpm.d/www.conf && \
    sed -i 's|;log_level\s*=\s*notice|log_level = notice|g' /etc/php7/php-fpm.d/www.conf

COPY apcu.ini /etc/php7/conf.d/apcu.ini

VOLUME [ "${SESSION_LOCATION}", "/var/www/localhost/htdocs" ]

ENTRYPOINT ["httpd","-D","FOREGROUND"]
