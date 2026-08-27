FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Cache Maven dependencies separately from the website source.
COPY pom.xml ./
RUN mvn -B dependency:go-offline

COPY . ./
RUN mvn -B clean package

FROM tomcat:10.1-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/moxkon.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
