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
ARG DOCKER_PROJECT_NODEJS_VERSION
ARG DOCKER_PROJECT_NODEJS_UBUNTU_EXTRA_PACKAGES
ARG DOCKER_PROJECT_NODEJS_NODEJS_EXTRA_GLOBAL_PACKAGES
ARG DOCKER_PROJECT_NODEJS_START_CMD
ARG DOCKER_PROJECT_PORT_NODEJS
ARG DOCKER_PROJECT_MAIL_DOMAIN
ARG DOCKER_PROJECT_MAIL_SMTP_HOST
ARG DOCKER_PROJECT_MAIL_SMTP_PORT
ARG DOCKER_PROJECT_MAIL_USER
ARG DOCKER_PROJECT_MAIL_PASSWORD
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

RUN usermod -s /bin/bash -u $IMAGE_USER_UID -o $WEB_USER && groupmod -g $IMAGE_USER_GID -o $WEB_USER
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


RUN printf "${CSC}Installing Extra Apps(${DOCKER_PROJECT_NODEJS_UBUNTU_EXTRA_PACKAGES})...${NRC}\n"			

RUN sudo apt-get install -y ${DOCKER_PROJECT_NODEJS_UBUNTU_EXTRA_PACKAGES} > /dev/null

RUN printf "${CEC}Extra Apps Installed.${NRC}\n"			

RUN sudo mkdir /var/www			
RUN sudo chown -R $IMAGE_USER_UID:$IMAGE_USER_GID /var/www
RUN sudo chown -R $IMAGE_USER_UID:$IMAGE_USER_GID /usr/local/bin
RUN sudo chown -R $IMAGE_USER_UID:$IMAGE_USER_GID /usr/local/lib


RUN printf "${CSC}Installing Node ${DOCKER_PROJECT_NODEJS_VERSION}...${NRC}\n"

RUN curl -fsSL https://deb.nodesource.com/setup_${DOCKER_PROJECT_NODEJS_VERSION}.x | sudo -E bash -

RUN sudo apt-get install -y nodejs > /dev/null

RUN sudo chown -R $IMAGE_USER_UID:$IMAGE_USER_UID /usr/lib/node_modules

RUN npm config set prefix /usr/local

RUN printf "${CEC}Node ${DOCKER_PROJECT_NODEJS_VERSION} Installed.${NRC}\n"

RUN git config --global user.name "${DOCKER_PROJECT_GIT_USERNAME}"
RUN git config --global user.email ${DOCKER_PROJECT_GIT_EMAIL}


RUN echo $DOCKER_PROJECT_NODEJS_NODEJS_EXTRA_GLOBAL_PACKAGES
RUN printf "${CSC}Installing NPM Gloabl Packages(${DOCKER_PROJECT_NODEJS_NODEJS_EXTRA_GLOBAL_PACKAGES})...${NRC}\n"			

RUN if [ "${DOCKER_PROJECT_NODEJS_NODEJS_EXTRA_GLOBAL_PACKAGES}" != "" ] ; then npm install -g ${DOCKER_PROJECT_NODEJS_NODEJS_EXTRA_GLOBAL_PACKAGES} > /dev/null ; fi

RUN printf "${CEC}NPM Gloabl Packages Installed.${NRC}\n"			


RUN printf "${CSC}Copying localhost certificates to server...${NRC}\n"			

ADD ./certs/localhost.crt /var/www/certs/
ADD ./certs/localhost.key /var/www/certs/

RUN printf "${CEC}localhost certificates copied to server.${NRC}\n"

EXPOSE ${DOCKER_PROJECT_PORT_NODEJS}

WORKDIR /var/www/html

# CMD ${DOCKER_PROJECT_NODEJS_START_CMD}
CMD sudo sh -c 'sleep infinity'