FROM alpine:3.15

MAINTAINER resyst-it <florian.cauzardjarry@gmail.com>

RUN apk --update --no-cache add bind bind-dnssec-tools

EXPOSE 53

CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]
