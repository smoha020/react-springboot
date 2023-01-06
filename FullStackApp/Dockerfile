FROM openjdk:8
ADD target/react-springboot.jar react-springboot.jar
COPY /src /src
ENTRYPOINT ["java", "-jar", "react-springboot.jar"]
