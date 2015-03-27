FROM gliderlabs/alpine:latest

MAINTAINER resyst-it <support@resyst-it.fr>

RUN apk-install bind

EXPOSE 53

CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]
