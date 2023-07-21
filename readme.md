# 自定义nginx

## 集成模块

rtmp, echo, lua

## VOD视频点播

使用http做视频点播是最合适的解决方案. 但在家庭网络搭建可能存在端口被封的情况. rtmp是直播协议，可减少被封的概率。

### 编译安装nginx rtmp插件

    docker build -t nginx-rtmp .

### 配置nginx rtmp

    nginx.conf (rtmp)

### 启动docker

    docker-compose up -d

### 测试

    mac使用iina软件正常.
    vlc拖动进度有问题. 
    浏览器需要使用flash未调通. (rtmp_demo/ 或者 rtmp_test.html)

### 直播大都将rtmp迁移为webrtc. 各平台兼容性更好

## log

2020-05-18 增加  --add-module=/tmp/ngx_devel_kit
                --add-module=/tmp/lua-nginx-module

2020-05-18 增加 --add-module=/tmp/echo-nginx-module-0.61
