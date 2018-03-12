FROM openjdk:7
RUN mkdir -p /app/spring-framework-petclinic
WORKDIR /app/spring-framework-petclinic
ADD . /app/spring-framework-petclinic
RUN ln -s /app/spring-framework-petclinic/.m2 /root/.m2
EXPOSE 8080
CMD ["./mvnw", "tomcat7:run-war", "-P", "PostgreSQL", "-Dmaven.test.skip=true"]
