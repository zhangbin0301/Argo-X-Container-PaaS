# FROM node:latest
# EXPOSE 3000
# WORKDIR /app
# COPY files/* /app/

#RUN apt-get update &&\
#    apt-get install -y iproute2 &&\
#    npm install -r package.json &&\
#    npm install -g pm2 &&\
#    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
#    dpkg -i cloudflared.deb &&\
#    rm -f cloudflared.deb &&\
#    chmod +x web.js

# ENTRYPOINT [ "node", "server.js" ]
######################################################################
# 使用一个基础镜像
FROM node:latest
EXPOSE 3000
# 更新包管理工具，安装一些必要的工具
RUN apt update -y &&\
    apt install curl sudo wget unzip iproute2 systemctl -y &&\
    npm install -r package.json &&\ 
    npm install -g pm2 &&\

# 将 root 用户的密码修改为 10086
RUN echo 'root:10086' | chpasswd
# 添加一个新用户，并将其添加到 sudo 组中
RUN useradd -m cmcc -u 10086  && echo 'cmcc:10086' | chpasswd  && usermod -aG sudo cmcc

# 切换到新用户，并在其主目录中创建一个 app 文件夹
USER 10086
WORKDIR /app

# 复制配置文件和启动脚本
COPY nginx.conf /etc/nginx/nginx.conf
COPY files/* /app/

# 下载并安装 Xray
RUN wget -O temp.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip temp.zip xray && \
    rm -f temp.zip && \
    echo "10086" | sudo -S chmod a+x xray entrypoint.sh web.js  
    
RUN wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
     dpkg -i cloudflared.deb &&\
     rm -f cloudflared.deb &&\ 
     echo "10086" | sudo -S chmod a+x cloudflared.deb 
    


ENTRYPOINT [ "./entrypoint.sh" ]
