# Stage 1: Build với Maven
FROM maven:3-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Chạy ứng dụng
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Render sử dụng biến môi trường PORT, mặc định là 10000 nếu không có
ENV PORT 8080
EXPOSE $PORT

# Chạy ứng dụng trên cổng được Render chỉ định
ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT}"]
