FROM node:lts-alpine
RUN apk add curl dropbear sudo bash git make g++ python3 wget unzip zip musl libgcc libstdc++

# SSH User
RUN addgroup developer
RUN adduser --ingroup developer -u 9000 developer --disabled-password
RUN echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && chmod 0440 /etc/sudoers.d/developer

# Allow dropbear to read /etc/shadow for password authentication without running dropbear as root
RUN adduser developer shadow

COPY ./Entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 22
USER developer
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]