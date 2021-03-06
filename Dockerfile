FROM golang:onbuild as build
Maintainer Mahmoud Gamal <mhmoudgmal.89@gmail.com>

RUN go get gopkg.in/yaml.v2 &\
    go get gotest.tools/assert

RUN go test -v

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o localstack-single-endpoint

FROM alpine as app
Maintainer Mahmoud Gamal <mhmoudgmal.89@gmail.com>

COPY --from=build /go/src/app/localstack-single-endpoint /
COPY --from=build /go/src/app/services.yml /

ENV LOCALSTACK_HOST "localhost"

EXPOSE 9000

CMD ["sh", "-c", "/localstack-single-endpoint -localstackHost ${LOCALSTACK_HOST}"]
