FROM alpine as plugins

RUN wget -o /tmp/out_logzio.so \
    https://github.com/logzio/fluent-bit-logzio-output/raw/master/build/out_logzio-linux.so

FROM fluent/fluent-bit:1.7

LABEL maintainer="ingcsmoreno@gmail.com"

COPY --from=plugins /tmp/out_logzio.so /fluent-bit/plugins/
