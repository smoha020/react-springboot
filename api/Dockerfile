FROM openjdk:8
ADD target/bookworld.jar bookworld.jar
COPY /src /src
ENTRYPOINT ["java", "-jar", "bookworld"]
