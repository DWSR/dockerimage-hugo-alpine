FROM golang:1.12.3-alpine3.9 AS builder

ARG HUGO_VERSION=0.55.1

RUN apk add alpine-sdk upx
RUN git clone --branch v${HUGO_VERSION} https://github.com/gohugoio/hugo.git && \
    cd hugo && \
    go install --tags extended && \
    strip $(which hugo) && \
    upx $(which hugo)

FROM alpine:3.9

# Required to get Hugo running.
RUN apk add libstdc++ libgcc

WORKDIR /hugo-site
EXPOSE 1313
CMD ["hugo", "server", "--baseURL=http://localhost:1313", "--bind=0.0.0.0"]

COPY --from=builder /go/bin/hugo /bin/hugo
