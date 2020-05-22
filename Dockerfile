FROM alpine:3.11

RUN apk add --no-cache mysql-client

RUN cd /usr/bin \ 
	&& wget https://dl.min.io/client/mc/release/linux-amd64/mc \
	&& chmod +x mc

COPY backup.sh /backup.sh
RUN chmod 777 /*.sh

CMD sh /backup.sh