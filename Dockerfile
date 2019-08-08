FROM alpine
LABEL \
	maintainer="Davide Alberani <da@mimante.net>"

RUN \
	apk add --no-cache \
		coreutils \
		curl \
		jq
COPY toot.sh rm.sh /
WORKDIR /
VOLUME /rm

ENTRYPOINT ["/rm.sh"]

