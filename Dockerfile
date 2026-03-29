# Step 1: Build Stage
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Runtime Stage
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the generated WAR file from the build stage
# Assuming the WAR name matches what's in your pom.xml (usually artifactId.war)
COPY --from=build /app/target/elms.war /app/elms.war

# Download WebApp Runner to run the WAR file
RUN apt-get update && apt-get install -y curl && \
    curl -L https://repo1.maven.org/maven2/com/github/jsimone/webapp-runner/9.0.83.0/webapp-runner-9.0.83.0.jar -o webapp-runner.jar

# Render provides a $PORT environment variable
EXPOSE 8080

# Start WebApp Runner
CMD java -jar webapp-runner.jar --port $PORT /app/elms.war
