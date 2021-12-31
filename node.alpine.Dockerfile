FROM node:lts-alpine
RUN apk add curl dropbear sudo bash git make g++ python3
RUN addgroup developer
RUN adduser --ingroup developer developer --disabled-password
RUN echo "developer ALL=(ALL) ALL" > /etc/sudoers.d/developer && chmod 0440 /etc/sudoers.d/developer
RUN mkdir /etc/dropbear 
COPY ./alpine.Entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 22
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]