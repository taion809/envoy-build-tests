FROM golang:latest
WORKDIR /go/src/github.com/taion809/envoy-build-tests
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o envoy .

FROM ubuntu:16.04
LABEL MAINTAINER="Nicholas J <nicholas.johns@jet.com>"
COPY --from=0 /go/src/github.com/taion809/envoy-build-tests/envoy /usr/bin/envoy
RUN apt-get update \
    && apt-get install -y curl ca-certificates openssl \
    && apt-get upgrade -y curl ca-certificates openssl

EXPOSE 5555
CMD [ "/usr/bin/envoy" ]
