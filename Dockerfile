# Stage 1: Build using official pre-installed Maven & JDK 17
FROM maven:3.9.9-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# Copy pom.xml and source code only
COPY pom.xml ./
COPY src ./src

# Build production JAR
RUN mvn clean package -DskipTests

# Stage 2: Minimal Runtime Environment
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the generated JAR from builder
COPY --from=builder /app/target/petcare-connect-1.0.0.jar app.jar

EXPOSE 8080
ENV PORT=8080

ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar app.jar"]
