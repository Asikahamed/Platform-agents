# ==================================================
# Build Stage
# ==================================================
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy pom first for dependency caching
COPY pom.xml .

RUN mvn dependency:go-offline -B

# Copy complete project
COPY . .

# Build application
RUN mvn clean package -DskipTests

# ==================================================
# Runtime Stage
# ==================================================
FROM eclipse-temurin:21-jre

WORKDIR /app

RUN addgroup --system spring && \
    adduser --system --ingroup spring spring

COPY --from=builder /app/target/*.jar app.jar

USER spring

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]