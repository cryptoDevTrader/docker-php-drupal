FROM php:5.5-fpm

ENV DRUPAL_TARGZ https://github.com/pressflow/6/tarball/master

# Install Drupal
RUN curl -SL ${DRUPAL_TARGZ} -o drupal.tar.gz \
    && tar -xof drupal.tar.gz -C /var/www/html --strip-components=1 \
    && rm drupal.tar.gz

# Update APT cache
RUN apt-get update

# Install GD Extension
RUN apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/us \
    && docker-php-ext-install gd

# Install imagick Extension
RUN apt-get install -y libmagickwand-6.q16-dev --no-install-recommends \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ \
    && pecl install imagick \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini

# Install apcu Extension
RUN yes "" | pecl install channel://pecl.php.net/APCu-4.0.7 \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/ext-apcu.ini
    
# Install memcache Extension
RUN yes "" | pecl install memcache \
    && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/ext-memcache.ini

# Install curl Extension
RUN apt-get install -y libcurl4-openssl-dev \
    && docker-php-ext-install curl

# Install pspell Extension
RUN apt-get install -y libpspell-dev \
    && docker-php-ext-install pspell

# Install snmp Extension
RUN apt-get install -y libsnmp-dev \
    && docker-php-ext-install snmp

# Install xsl Extension
RUN apt-get install -y libxslt1-dev \
    && docker-php-ext-install xsl

# Install additional Extensions
RUN docker-php-ext-install \
  opcache \
  sockets \
  json \
  mysql \
  mysqli \
  pdo \
  pdo_mysql \
  xmlrpc \
  mbstring

CMD ["php-fpm"]