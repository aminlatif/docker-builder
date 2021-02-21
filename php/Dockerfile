FROM ubuntu

ARG CSC="\033[0;35m"
ARG CEC="\033[0;32m"
ARG IFC="\033[1;34m"
ARG NRC="\033[0;37m"

RUN printf "${CSC}Assiging Arguments...${NRC}\n"

ARG IMAGE_USER
ARG IMAGE_USER_UID
ARG IMAGE_USER_GID
ARG WEB_USER
ARG DOCKER_PROJECT_NAME
ARG DOCKER_PROJECT_TIMEZONE
ARG DOCKER_PROJECT_PHP_VERSION
ARG DOCKER_PROJECT_NODEJS_VERSION
ARG DOCKER_PROJECT_UBUNTU_EXTRA_PACKAGES
ARG DOCKER_PROJECT_COMPOSER_EXTRA_GLOBAL_PACKAGES
ARG DOCKER_PROJECT_NODEJS_EXTRA_GLOBAL_PACKAGES
ARG DOCKER_PROJECT_MAIL_DOMAIN
ARG DOCKER_PROJECT_MAIL_SMTP_HOST
ARG DOCKER_PROJECT_MAIL_SMTP_PORT
ARG DOCKER_PROJECT_MAIL_USER
ARG DOCKER_PROJECT_MAIL_PASSWORD
ARG DOCKER_PROJECT_PHP_MEMORY_LIMIT
ARG DOCKER_PROJECT_PHP_XDEBUG_REMOTE_HOST
ARG DOCKER_PROJECT_PHP_XDEBUG_REMOTE_PORT
ARG DOCKER_PROJECT_GIT_USERNAME
ARG DOCKER_PROJECT_GIT_EMAIL
ARG DOCKER_PROJECT_SERVER_NAME
ARG DOCKER_PROJECT_SERVER_ALIAS

RUN printf "${CEC}Arguments Assigned.${NRC}\n"




RUN printf "${IFC}Environemnt Variables: \n"

RUN env

RUN printf "${NRC}\n"



RUN printf "${CSC}Initial Update Starting...${NRC}\n"

RUN apt-get update > /dev/null

RUN printf "${CEC}Initial Update Finished${NRC}\n"




RUN printf "${CSC}Configuring Users(${IMAGE_USER} and ${WEB_USER} width UID:${IMAGE_USER_UID} and GID:${IMAGE_USER_GID})...${NRC}\n"

RUN apt-get install -y sudo > /dev/null

RUN groupadd --gid $IMAGE_USER_GID $IMAGE_USER
RUN useradd -s /bin/bash --uid $IMAGE_USER_UID --gid $IMAGE_USER_GID -m $IMAGE_USER
RUN echo "$IMAGE_USER ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$IMAGE_USER
RUN chmod 0440 /etc/sudoers.d/$IMAGE_USER

RUN usermod -u $IMAGE_USER_UID -o $WEB_USER && groupmod -g $IMAGE_USER_GID -o $WEB_USER
RUN echo "$WEB_USER ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$WEB_USER
RUN chmod 0440 /etc/sudoers.d/$WEB_USER

USER ${IMAGE_USER_UID}:${IMAGE_USER_GID}

RUN sudo ln -snf /usr/share/zoneinfo/$DOCKER_PROJECT_TIMEZONE /etc/localtime
RUN sudo sh -c "echo $DOCKER_PROJECT_TIMEZONE > /etc/timezone"

RUN printf "${CEC}Configuring Users Finished.${NRC}\n"




RUN printf "${CSC}Installing Initial Updates...${NRC}\n"

RUN sudo apt-get -y update > /dev/null
RUN sudo apt-get -y upgrade > /dev/null
RUN sudo apt-get -y dist-upgrade > /dev/null

RUN printf "${CEC}Initial Updates Installed.${NRC}\n"




RUN printf "${CSC}Installing Required Apps...${NRC}\n"

RUN sudo apt-get install -y \
			software-properties-common \
			curl \
			nano \
			inetutils-ping \
			telnet \
			git \
			msmtp \
			> /dev/null
			
RUN printf "${CEC}Required Apps Installed.${NRC}\n"




RUN printf "${CSC}Installing PHP ${DOCKER_PROJECT_PHP_VERSION}...${NRC}\n"

RUN sudo add-apt-repository ppa:ondrej/php

RUN sudo apt-get -y update > /dev/null

RUN sudo apt-get install -y \
			php${DOCKER_PROJECT_PHP_VERSION} \
			php${DOCKER_PROJECT_PHP_VERSION}-mysql \
			php${DOCKER_PROJECT_PHP_VERSION}-xml \
			php${DOCKER_PROJECT_PHP_VERSION}-intl \
			php${DOCKER_PROJECT_PHP_VERSION}-curl \
			php${DOCKER_PROJECT_PHP_VERSION}-xdebug \
			php${DOCKER_PROJECT_PHP_VERSION}-bcmath \
			php${DOCKER_PROJECT_PHP_VERSION}-gd \
			php${DOCKER_PROJECT_PHP_VERSION}-mbstring \
			php${DOCKER_PROJECT_PHP_VERSION}-soap \
			php${DOCKER_PROJECT_PHP_VERSION}-zip \
			> /dev/null
			
RUN printf "${IFC}PHP Version: \n"

RUN php -v

RUN printf "\n${NRC}\n"

RUN printf "${CEC}PHP ${DOCKER_PROJECT_PHP_VERSION} Installed.${NRC}\n"
			
			
			
			
RUN printf "${CSC}Installing Apache...${NRC}\n"			

RUN sudo apt-get install -y apache2 > /dev/null

RUN printf "${CEC}Apache Installed.${NRC}\n"			



RUN printf "${CSC}Installing Mysql Client...${NRC}\n"			

RUN sudo apt-get install -y mysql-client > /dev/null

RUN printf "${CEC}Mysql Client Installed.${NRC}\n"			



RUN printf "${CSC}Installing Extra Apps(${DOCKER_PROJECT_UBUNTU_EXTRA_PACKAGES})...${NRC}\n"			

RUN sudo apt-get install -y ${DOCKER_PROJECT_UBUNTU_EXTRA_PACKAGES} > /dev/null

RUN printf "${CEC}Extra Apps Installed.${NRC}\n"			



			
RUN sudo chown -R $IMAGE_USER_UID:$IMAGE_USER_GID /var/www
RUN sudo chown -R $IMAGE_USER_UID:$IMAGE_USER_GID /usr/local/bin
RUN sudo chown -R $IMAGE_USER_UID:$IMAGE_USER_GID /usr/local/lib




RUN printf "${CSC}Installing Composer...${NRC}\n"

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer > /dev/null

RUN printf "${CEC}Composer Installed.${NRC}\n"			




RUN printf "${CSC}Installing Node ${DOCKER_PROJECT_NODEJS_VERSION}...${NRC}\n"

RUN curl -fsSL https://deb.nodesource.com/setup_${DOCKER_PROJECT_NODEJS_VERSION}.x | sudo -E bash -

RUN sudo apt-get install -y nodejs > /dev/null

RUN sudo chown -R $IMAGE_USER_UID:$IMAGE_USER_UID /usr/lib/node_modules

RUN npm config set prefix /usr/local

RUN printf "${CEC}Node ${DOCKER_PROJECT_NODEJS_VERSION} Installed.${NRC}\n"




RUN git config --global user.name "${DOCKER_PROJECT_GIT_USERNAME}"
RUN git config --global user.email ${DOCKER_PROJECT_GIT_EMAIL}



RUN printf "${CSC}Installing Compser Gloabl Packages(${DOCKER_PROJECT_COMPOSER_EXTRA_GLOBAL_PACKAGES})...${NRC}\n"			

RUN if [ "${DOCKER_PROJECT_COMPOSER_EXTRA_GLOBAL_PACKAGES}" != "" ] ; then composer global require ${DOCKER_PROJECT_COMPOSER_EXTRA_GLOBAL_PACKAGES} > /dev/null > /dev/null ; fi

RUN printf "${CEC}Compser Packages Installed.${NRC}\n"			



RUN echo $DOCKER_PROJECT_NODEJS_EXTRA_GLOBAL_PACKAGES
RUN printf "${CSC}Installing NPM Gloabl Packages(${DOCKER_PROJECT_NODEJS_EXTRA_GLOBAL_PACKAGES})...${NRC}\n"			

RUN if [ "${DOCKER_PROJECT_NODEJS_EXTRA_GLOBAL_PACKAGES}" != "" ] ; then npm install -g ${DOCKER_PROJECT_NODEJS_EXTRA_GLOBAL_PACKAGES} > /dev/null ; fi

RUN printf "${CEC}NPM Gloabl Packages Installed.${NRC}\n"			




RUN printf "${CSC}Copying localhost certificates to server...${NRC}\n"			

ADD ./certs/localhost.crt /var/www/certs/
ADD ./certs/localhost.key /var/www/certs/

RUN printf "${CEC}localhost certificates copied to server.${NRC}\n"




RUN printf "${CSC}Copying PHP ${DOCKER_PROJECT_PHP_VERSION} config files to server...${NRC}\n"			

ADD ./php-conf/custom.ini /etc/php/${DOCKER_PROJECT_PHP_VERSION}/cli/conf.d/
ADD ./php-conf/custom.ini /etc/php/${DOCKER_PROJECT_PHP_VERSION}/apache2/conf.d/

RUN sudo sed -i "s/{{DOCKER_PROJECT_PHP_MEMORY_LIMIT}}/-1/g" /etc/php/${DOCKER_PROJECT_PHP_VERSION}/cli/conf.d/custom.ini
RUN sudo sed -i "s/{{DOCKER_PROJECT_PHP_MEMORY_LIMIT}}/${DOCKER_PROJECT_PHP_MEMORY_LIMIT}/g" /etc/php/${DOCKER_PROJECT_PHP_VERSION}/apache2/conf.d/custom.ini

RUN sudo sed -i "s/{{DOCKER_PROJECT_NAME}}/${DOCKER_PROJECT_NAME}/g" /etc/php/${DOCKER_PROJECT_PHP_VERSION}/cli/conf.d/custom.ini
RUN sudo sed -i "s/{{DOCKER_PROJECT_NAME}}/${DOCKER_PROJECT_NAME}/g" /etc/php/${DOCKER_PROJECT_PHP_VERSION}/apache2/conf.d/custom.ini

RUN sudo sed -i "s/{{DOCKER_PROJECT_PHP_XDEBUG_REMOTE_HOST}}/${DOCKER_PROJECT_PHP_XDEBUG_REMOTE_HOST}/g" /etc/php/${DOCKER_PROJECT_PHP_VERSION}/cli/conf.d/custom.ini
RUN sudo sed -i "s/{{DOCKER_PROJECT_PHP_XDEBUG_REMOTE_HOST}}/${DOCKER_PROJECT_PHP_XDEBUG_REMOTE_HOST}/g" /etc/php/${DOCKER_PROJECT_PHP_VERSION}/apache2/conf.d/custom.ini

RUN sudo sed -i "s/{{DOCKER_PROJECT_PHP_XDEBUG_REMOTE_PORT}}/${DOCKER_PROJECT_PHP_XDEBUG_REMOTE_PORT}/g" /etc/php/${DOCKER_PROJECT_PHP_VERSION}/cli/conf.d/custom.ini
RUN sudo sed -i "s/{{DOCKER_PROJECT_PHP_XDEBUG_REMOTE_PORT}}/${DOCKER_PROJECT_PHP_XDEBUG_REMOTE_PORT}/g" /etc/php/${DOCKER_PROJECT_PHP_VERSION}/apache2/conf.d/custom.ini

RUN printf "${IFC}Cli Custom.ini: \n"

RUN cat /etc/php/${DOCKER_PROJECT_PHP_VERSION}/cli/conf.d/custom.ini

RUN printf "${NRC}\n"

RUN printf "${IFC}Apache Custom.ini: \n"

RUN cat /etc/php/${DOCKER_PROJECT_PHP_VERSION}/apache2/conf.d/custom.ini

RUN printf "\n${NRC}\n"

RUN printf "${CEC}PHP ${DOCKER_PROJECT_PHP_VERSION} config files copied to server.${NRC}\n"			




RUN printf "${CSC}Copying apache config files to server...${NRC}\n"			

RUN sudo a2enmod ssl
RUN sudo a2enmod rewrite

ADD ./server-conf/apache/000-default.conf /etc/apache2/sites-enabled/
ADD ./server-conf/apache/default-ssl.conf /etc/apache2/sites-enabled/

RUN sudo sed -i "s/{{DOCKER_PROJECT_SERVER_NAME}}/${DOCKER_PROJECT_SERVER_NAME}/g" /etc/apache2/sites-enabled/000-default.conf
RUN sudo sed -i "s/{{DOCKER_PROJECT_SERVER_NAME}}/${DOCKER_PROJECT_SERVER_NAME}/g" /etc/apache2/sites-enabled/default-ssl.conf

RUN sudo sed -i "s/{{DOCKER_PROJECT_SERVER_ALIAS}}/${DOCKER_PROJECT_SERVER_ALIAS}/g" /etc/apache2/sites-enabled/000-default.conf
RUN sudo sed -i "s/{{DOCKER_PROJECT_SERVER_ALIAS}}/${DOCKER_PROJECT_SERVER_ALIAS}/g" /etc/apache2/sites-enabled/default-ssl.conf

RUN printf "${IFC}Apache 000-default.conf: \n"

RUN cat /etc/apache2/sites-enabled/000-default.conf

RUN printf "${NRC}\n"

RUN printf "${IFC}Apache default-ssl.conf: \n"

RUN cat /etc/apache2/sites-enabled/default-ssl.conf

RUN printf "\n${NRC}\n"

RUN printf "${CEC}apache config files copied to server.${NRC}\n"			



RUN printf "${CSC}Copying mail config files to server...${NRC}\n"			

ADD ./mail-conf/msmtprc /etc/

RUN sudo sed -i "s/{{DOCKER_PROJECT_MAIL_DOMAIN}}/${DOCKER_PROJECT_MAIL_DOMAIN}/g" /etc/msmtprc
RUN sudo sed -i "s/{{DOCKER_PROJECT_MAIL_SMTP_HOST}}/${DOCKER_PROJECT_MAIL_SMTP_HOST}/g" /etc/msmtprc
RUN sudo sed -i "s/{{DOCKER_PROJECT_MAIL_SMTP_PORT}}/${DOCKER_PROJECT_MAIL_SMTP_PORT}/g" /etc/msmtprc
RUN sudo sed -i "s/{{DOCKER_PROJECT_MAIL_USER}}/${DOCKER_PROJECT_MAIL_USER}/g" /etc/msmtprc
RUN sudo sed -i "s|{{DOCKER_PROJECT_MAIL_PASSWORD}}|${DOCKER_PROJECT_MAIL_PASSWORD}|g" /etc/msmtprc

RUN printf "${IFC}Mail msmtprc: \n"

RUN cat /etc/msmtprc

RUN printf "\n${NRC}\n"

RUN printf "${CEC}mail config files copied to server.${NRC}\n"			



EXPOSE 80
EXPOSE 443

WORKDIR /var/www/html

CMD sudo sh -c 'service apache2 start && sleep infinity'
