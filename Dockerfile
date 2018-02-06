# set author and base
FROM fedora
MAINTAINER Alex Egorov

LABEL HEKETI_VERSION="v5.0.1"
LABEL description="Development build"

# let's setup all the necessary environment variables
ENV HEKETI_VERSION=v5.0.1
ENV BUILD_HOME=/build
ENV GOPATH=$BUILD_HOME/golang
ENV PATH=$GOPATH/bin:$PATH
ENV HEKETI_BRANCH="master"

# install dependencies, build and cleanup
#RUN mkdir $BUILD_HOME $GOPATH && \
#    dnf -y install glide golang git make && \
#    dnf -y clean all && \
#    mkdir -p $GOPATH/src/github.com/heketi && \
#    cd $GOPATH/src/github.com/heketi && \
#    git clone -b $HEKETI_BRANCH https://github.com/heketi/heketi.git && \
#    cd $GOPATH/src/github.com/heketi/heketi && \
#    glide install -v && \
#    make && \
#    cp heketi /usr/bin/heketi && \
#    cp client/cli/go/heketi-cli /usr/bin/heketi-cli && \
#    glide cc && \
#    cd && rm -rf $BUILD_HOME && \
#    dnf -y remove git glide golang && \
#    dnf -y autoremove && \
#    dnf -y clean all

# post install config and volume setup
ADD ./heketi.json /etc/heketi/heketi.json
ADD ./heketi-start.sh /usr/bin/heketi-start.sh

RUN curl -L https://github.com/heketi/heketi/releases/download/${HEKETI_VERSION}/heketi-${HEKETI_VERSION}.linux.amd64.tar.gz \
        | tar -xz --strip-components=1 -C /usr/bin \
    && chmod +x /usr/bin/heketi \
    && chmod +x /usr/bin/heketi-cli \
    && chmod +x /usr/bin/heketi-start.sh


VOLUME /etc/heketi

RUN mkdir /var/lib/heketi
VOLUME /var/lib/heketi

# expose port, set user and set entrypoint with config option
ENTRYPOINT ["/usr/bin/heketi-start.sh"]
EXPOSE 8080