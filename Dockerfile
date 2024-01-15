# Use an official Maven image as a build stage
FROM maven:3.8.4-openjdk-11-slim AS build

# Set the working directory in the build stage
WORKDIR /app

# Copy the source code to the build stage
COPY . .

# Build the application
RUN mvn clean package

# Use a smaller OpenJDK image as the final stage
FROM openjdk:11-jre-slim

# Set the working directory in the final stage
WORKDIR /app

# Copy the JAR file from the build stage to the final stage
COPY --from=build /app/target/your-application.jar .

# Specify the command to run on container start
CMD ["java", "-jar", "your-application.jar"]
