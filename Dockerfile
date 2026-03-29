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

# Download Jetty Runner to run the WAR file (Jetty 9.4.x compatible with Servlet 4.0)
RUN apt-get update && apt-get install -y curl && \
    curl -L https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-runner/9.4.53.v20231009/jetty-runner-9.4.53.v20231009.jar -o jetty-runner.jar

# Render provides a $PORT environment variable
EXPOSE 8080

# Start Jetty Runner
# We listen on 0.0.0.0 because Render requires it for networking
CMD java -jar jetty-runner.jar --port $PORT --host 0.0.0.0 /app/elms.war
