# Step 1: Build Stage
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Runtime Stage
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the runners and WAR from the build stage
COPY --from=build /app/target/elms.war /app/elms.war
COPY --from=build /app/target/webapp-runner.jar /app/webapp-runner.jar

# Render provides a $PORT environment variable
EXPOSE 8080

# Start WebApp Runner
CMD java -jar webapp-runner.jar --port $PORT /app/elms.war
