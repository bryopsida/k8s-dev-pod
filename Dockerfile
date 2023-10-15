FROM ubuntu:kinetic-20230624
ARG COMMIT=""
ENV COMMIT_SHA=${COMMIT}
ENV DEBIAN_FRONTEND=noninteractive
RUN echo ${COMMIT} > /etc/docker-image-version.txt
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "LANG=en_US.UTF-8" >> /etc/environment


RUN apt-get update && \
  apt-get install -y curl dropbear-bin sudo gcc g++ make python3 zsh vim wget htop nano openssh-client gnupg2 ca-certificates apt-transport-https ncdu tcpdump tldr bat && \
  apt-get install -y --no-install-recommends git  

# Helm
RUN curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -  && \
  echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list && \
  apt-get update && \
  apt-get install -y helm


# Kubectl
RUN apt-get update && \
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
  apt-get update && \
  apt-get install -y kubectl


RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh && \
  chmod +x nodesource_setup.sh && \
  ./nodesource_setup.sh && \
  apt-get update &&\
  apt-get install -y --no-install-recommends nodejs

RUN apt-get install -y default-jdk

# SSH User
RUN useradd -ms /bin/zsh developer
RUN echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && chmod 0440 /etc/sudoers.d/developer

# set zsh shell
RUN usermod -s /bin/zsh developer

# Allow dropbear to read /etc/shadow for password authentication without running dropbear as root
RUN adduser developer shadow

COPY ./Entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./PrepareHome.sh /usr/local/bin/prepare_home.sh
EXPOSE 3022/tcp
USER developer
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]