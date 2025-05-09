FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copy toàn bộ project
COPY . .

# Clean và package
RUN mvn clean package -DskipTests

# Kiểm tra file WAR đã tồn tại chưa
RUN ls -la target/

# Giai đoạn runtime
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy file WAR từ build stage
COPY --from=build /app/target/*.war app.war
EXPOSE 8080 

ENTRYPOINT ["java","-jar","app.war"]
