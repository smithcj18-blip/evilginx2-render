FROM golang:1.21 AS build
RUN git clone https://github.com/kgretzky/evilginx2 /app
WORKDIR /app
RUN go build -o evilginx2

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates
COPY --from=build /app/evilginx2 /usr/local/bin/evilginx2
COPY --from=build /app/phishlets /phishlets
COPY --from=build /app/redirectors /redirectors
WORKDIR /phishlets
EXPOSE 443
CMD ["evilginx2", "-developer", "-p", "/phishlets"]
