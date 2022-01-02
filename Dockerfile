FROM ubuntu:focal
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y curl dropbear-bin sudo gcc g++ make python3 zsh vim wget htop nano openssh-client
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git

RUN curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod 700 /tmp/get_helm.sh && /tmp/get_helm.sh
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(uname -m)/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

RUN apt-get install -y default-jdk

# SSH User
RUN useradd -ms /bin/bash developer
RUN echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && chmod 0440 /etc/sudoers.d/developer

# Allow dropbear to read /etc/shadow for password authentication without running dropbear as root
RUN adduser developer shadow

COPY ./Entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 3022/tcp
USER developer
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]