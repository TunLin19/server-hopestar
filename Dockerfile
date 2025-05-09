FROM maven:3-openjdk-17 AS build
WORKDIR /app

# Copy file cấu hình Maven trước
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY mvnw.cmd .

# Tải dependencies
RUN mvn dependency:go-offline

# Copy mã nguồn
COPY src src

# Đóng gói ứng dụng
RUN mvn package -DskipTests

# Giai đoạn runtime
FROM openjdk:17-jdk-slim
WORKDIR /app

COPY --from=build /app/target/be-0.0.1-SNAPSHOT.war be.war
EXPOSE 8080 

ENTRYPOINT ["java","-jar","be.war"]
