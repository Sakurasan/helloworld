FROM golang:1.15.9-alpine AS builder
LABEL anther="cjun"
WORKDIR /app
COPY ./main.go /app
ENV GO111MODULE=off
RUN GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o  hello main.go

FROM alpine:latest AS runner
# 设置alpine 时间为上海时间
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata
COPY --from=builder /app/hello /app/hello 
WORKDIR /app
EXPOSE 80
CMD ["./hello"]
