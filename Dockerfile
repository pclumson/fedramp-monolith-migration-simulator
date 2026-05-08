# Use OpenJDK 21 as the base image
FROM openjdk:21-jdk-slim

COPY target/comparison-0.0.1-SNAPSHOT.jar /usr/app/comparison.jar

CMD ["java", "-jar", "/usr/app/comparison.jar"]

