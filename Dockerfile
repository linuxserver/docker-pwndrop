FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PWNDROP_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN \
 echo "**** install pwndrop ****" && \
 if [ -z ${PWNDROP_RELEASE+x} ]; then \
	PWNDROP_RELEASE=$(curl -sX GET "https://api.github.com/repos/kgretzky/pwndrop/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p /app/pwndrop && \
 curl -o \
	/tmp/pwndrop.tar.gz -L \
	"https://github.com/kgretzky/pwndrop/releases/download/${PWNDROP_RELEASE}/pwndrop-linux-amd64.tar.gz" && \
 tar xzf /tmp/pwndrop.tar.gz -C \
	/app/pwndrop --strip-components=1 && \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 8080 4443
