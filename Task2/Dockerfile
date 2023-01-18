FROM alpine

RUN wget -O /home/ec2-user/sagan-site-1.0.0-SNAPSHOT.jar https://artifactory.com/myrepo/sagan-site-1.0.0-SNAPSHOT.jar
COPY executable.sh /home/ec2-user
ENTRYPOINT /home/ec2-user/executable.sh