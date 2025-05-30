# 构建阶段
FROM maven:3.8-openjdk-8 AS builder

# 添加元数据
LABEL maintainer="jihuayu <jihuayu123@gmail.com>"
LABEL description="专注文件在线预览服务(fork by kekingcn/kkFileView)"
LABEL license="Apache-2.0"
LABEL url="https://github.com/jihuayu/kkFileView"

# 设置工作目录
WORKDIR /app

# 复制pom文件和源代码
COPY pom.xml .
COPY server/ server/

# 构建项目
RUN mvn clean package -DskipTests

# 运行阶段
FROM openjdk:8-jre

# 添加元数据
LABEL maintainer="jihuayu <jihuayu123@gmail.com>"
LABEL description="专注文件在线预览服务(fork by kekingcn/kkFileView)"
LABEL license="Apache-2.0"
LABEL url="https://github.com/jihuayu/kkFileView"

# 设置工作目录
WORKDIR /opt

# 从构建阶段复制构建好的应用
COPY --from=builder /app/server/target/kkFileView-*.tar.gz .
RUN tar -xzf kkFileView-*.tar.gz && \
    mv kkFileView-* kkFileView && \
    rm kkFileView-*.tar.gz

# 设置环境变量
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView/bin
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

# 声明端口
EXPOSE 8012

# 启动命令
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView/config/application.properties","-jar","/opt/kkFileView/bin/kkFileView-*.jar"]