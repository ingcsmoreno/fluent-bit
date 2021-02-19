FROM golang:1.15-alpine as plugins

RUN apk add --update git build-base 

RUN git clone https://github.com/logzio/fluent-bit-logzio-output.git /go/src/logzio \
 && go get -u github.com/golang/dep/cmd/dep 

WORKDIR /go/src/logzio

RUN dep ensure -v \
 && go build -a -tags netgo -ldflags '-w -extldflags "-static"' -buildmode=c-shared -o build/out_logzio.so ./output

FROM fluent/fluent-bit:1.7

LABEL maintainer="ingcsmoreno@gmail.com"

COPY --from=plugins /go/src/logzio/build/out_logzio.so /fluent-bit/plugins/
COPY --from=plugins /lib/ld-musl-*.so.1 /lib/
