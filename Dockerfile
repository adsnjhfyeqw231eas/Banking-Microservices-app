FROM openjdk:11
ARG JAR_FILE=target/banking-0.0.1-SNAPSHOT.jar
EXPOSE 8081
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","app.jar"]
