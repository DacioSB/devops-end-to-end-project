FROM maven as build

WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11-jre-slim

WORKDIR /app
COPY --from=build /app/target/Uber.jar /app/
EXPOSE 9090
ENTRYPOINT ["java", "-jar", "Uber.jar"]