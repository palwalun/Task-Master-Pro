FROM eclipse-temurin:17.0.17_10-jre-alpine-3.23
WORKDIR /app
COPY target/*.war app.war
EXPOSE 8080
CMD ["java", "-jar", "app.war"]