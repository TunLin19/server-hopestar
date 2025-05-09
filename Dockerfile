FROM maven:3-openjdk-17 AS build

COPY . .
RUN mvn clean package -DskipTests


FROM openjdk:17-jdk-slim

COPY --from=build /target/*.jar be.jar
EXPOSE 8080 

ENTRYPOINT ["java","-jar","be.jar"]