FROM openjdk:11.0.1-jre-slim-stretch

RUN \
  apt-get update && apt-get install && \
  useradd --home-dir /home/webgoat --create-home -U webgoat

COPY ./webgoat-server-8.2.2.jar /home/webgoat/webgoat.jar

USER webgoat
RUN cd /home/webgoat/

EXPOSE 8080

WORKDIR /home/webgoat
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/home/webgoat/webgoat.jar"]
CMD ["--server.port=8080", "--server.address=0.0.0.0"]
