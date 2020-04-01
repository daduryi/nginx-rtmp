# rtmp协议流媒体

## VOD视频点播

使用http做视频点播是最合适的解决方案. 但在家庭网络搭建可能存在端口被封的情况.

### 编译安装nginx rtmp插件

    Dockerfile

### 配置nginx rtmp

    nginx.conf (rtmp)

### 启动docker

    docker-compose up -d

### 测试

    mac使用iina软件正常.
    vlc拖动进度有问题. 
    浏览器需要使用flask rtmp_demo, 未调通.