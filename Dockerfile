FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Copy Maven configuration files first
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
COPY mvnw.cmd .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src src

# Clean and package
RUN mvn clean package -DskipTests

# Debug: List target directory
RUN ls -la target/

# Runtime stage
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy WAR file from build stage
COPY --from=build /app/target/be-0.0.1-SNAPSHOT.war app.war
EXPOSE 8080 

# Use the correct WAR filename
ENTRYPOINT ["java","-jar","app.war"]
