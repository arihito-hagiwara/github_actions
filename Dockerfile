# 最新にするとbuildが転けたので、バージョン指定しています。(NW障害かもしれないが・・・)
FROM golang:1.24.10 AS builder

#RUN go install -trimpath go.k6.io/xk6/cmd/xk6@latest
RUN go install -trimpath go.k6.io/xk6/cmd/xk6@v1.2.3

RUN xk6 build --output "/tmp/k6" --with github.com/grafana/xk6-sql@latest --with github.com/grafana/xk6-sql-driver-mysql --with github.com/LeonAdato/xk6-output-statsd

FROM alpine:latest

# macでbuildする場合に、v2がうまくいかないので、v1をaptでisntall(s3 cpしか使わないので問題ない)
RUN apk add --no-cache aws-cli
#RUN apk add --no-cache curl unzip \
#    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#    && unzip awscliv2.zip \
#    && ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update \
#    && rm -rf awscliv2.zip aws

COPY --from=builder /tmp/k6 /usr/bin/k6
#ENV SCRIPT sample.js
ENV K6_STATSD_ENABLE_TAGS=true DB_INFO=cm9vdDpzaXUyd19KM0BtXkUxKjg1QTRAdGNwKDEwLjAuMTUwLjk4OjQwMDApL2s2ZGI=
#COPY ./test /test
COPY --chown=root:root --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["k6", "run", "--out", "output-statsd", "-q", "scenario.js" ]
