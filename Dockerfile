FROM centos:7
MAINTAINER breakinfenro <1972952841@qq.com>

RUN yum -y update && yum clean all && \
    yum -y install epel-release && \
    makdir -p /go && chmod -R 777 /go && \
    mkdir -p /go/bin && \
    mkdir -p /app/bin
    yum -y install git golang && \
    yum clean all
ENV GOPATH /go
ENV PATH="/go/bin:${PATH}"
RUN go get github.com/mattn/goreman

ADD etcd/etcd /app/bin
ADD etcd/etcdctl /app/bin
ADD Procfile /app
ADD goreman/goreman /app
EXPOSE 2379 22379 32379
WORKDIR /app

CMD ["/app/goreman", "start"]