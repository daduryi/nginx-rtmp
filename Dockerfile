FROM alpine

MAINTAINER Marin "lixuening7115@163.com"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN set -x
RUN addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx
RUN apk update
RUN apk upgrade
RUN apk add --no-cache --virtual .build-deps \
                gcc \
                libc-dev \
                make \
                openssl-dev \
                pcre-dev \
                zlib-dev \
                linux-headers \
                libxslt-dev \
                gd-dev \
                geoip-dev \
                perl-dev \
                libedit-dev \
                mercurial \
                bash \
                alpine-sdk \
                findutils

ADD LuaJIT-2.0.5 /tmp/LuaJIT
RUN cd /tmp/LuaJIT && make && make install

ADD nginx-1.17.9 /tmp/nginx
ADD nginx-rtmp-module-1.2.1 /tmp/nginx-rtmp-module
ADD echo-nginx-module-0.61 /tmp/echo-nginx-module-0.61
ADD lua-nginx-module-0.10.15 /tmp/lua-nginx-module
ADD ngx_devel_kit-0.3.1 /tmp/ngx_devel_kit

WORKDIR /tmp/nginx
RUN ./configure --prefix=/etc/nginx \
 --sbin-path=/usr/sbin/nginx \
 --modules-path=/usr/lib/nginx/modules \
 --conf-path=/etc/nginx/nginx.conf \
 --error-log-path=/var/log/nginx/error.log \
 --http-log-path=/var/log/nginx/access.log \
 --pid-path=/var/run/nginx.pid \
 --lock-path=/var/run/nginx.lock \
 --http-client-body-temp-path=/var/cache/nginx/client_temp \
 --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
 --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
 --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
 --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
 --user=nginx \
 --group=nginx \
 --with-compat \
 --with-file-aio \
 --with-threads \
 --with-http_addition_module \
 --with-http_auth_request_module \
 --with-http_dav_module \
 --with-http_flv_module \
 --with-http_gunzip_module \
 --with-http_gzip_static_module \
 --with-http_mp4_module \
 --with-http_random_index_module \
 --with-http_realip_module \
 --with-http_secure_link_module \
 --with-http_slice_module \
 --with-http_ssl_module \
 --with-http_stub_status_module \
 --with-http_sub_module \
 --with-http_v2_module \
 --with-mail \
 --with-mail_ssl_module \
 --with-stream \
 --with-stream_realip_module \
 --with-stream_ssl_module \
 --with-stream_ssl_preread_module \
 --with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.17.6/debian/debuild-base/nginx-1.17.6=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
 --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
 --add-module=/tmp/nginx-rtmp-module \
 --with-cc-opt="-Wimplicit-fallthrough=0" \
 --add-module=/tmp/echo-nginx-module-0.61 \
 --with-ld-opt="-Wl,-rpath,$LUAJIT_LIB" \
 --add-module=/tmp/ngx_devel_kit \   
 --add-module=/tmp/lua-nginx-module 

RUN make && make install
WORKDIR /
RUN rm -rf /tmp/nginx && rm -rf /tmp/nginx-rtmp-module

RUN ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/
RUN mkdir -p /var/cache/nginx/

EXPOSE 80 443 1935
CMD ["nginx", "-g", "daemon off;"]
