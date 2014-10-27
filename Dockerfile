FROM ubuntu:trusty


# Install packages
ENV DEBIAN_FRONTEND noninteractive


# Set locale (fix the locale warnings)
RUN locale-gen --purge en_US.UTF-8
RUN echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale


# Set timezone
RUN echo "Asia/Jerusalem"  > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata


RUN rm /etc/apt/sources.list
ADD sources.list /etc/apt/sources.list


RUN apt-get -y update
#installing software
RUN apt-get -y install supervisor  openssh-server
#ssh configs
RUN mkdir /root/.ssh
RUN mkdir /var/run/sshd

ADD sshkey.pub /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys
RUN sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config


RUN apt-get -y install nano curl tmux htop


#supervisor configs
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf


EXPOSE 22
#VOLUME ["/home/lalala/docker-manager/mesanenet-server/volumes/supervisor"]
CMD env | grep _ >> /etc/environment && /usr/bin/supervisord
