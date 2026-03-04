# Stage 1: Build WAR with Maven
FROM maven:3.8-openjdk-8 AS build
WORKDIR /build

COPY app/pom.xml .
RUN mvn dependency:go-offline -B

COPY app .
RUN mvn package -DskipTests -B

# Stage 2: Deploy to Tomcat
FROM tomcat:9.0-jdk8
WORKDIR /usr/local/tomcat

COPY --from=build /build/target/*.war webapps/app.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
