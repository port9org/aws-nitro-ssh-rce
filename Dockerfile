FROM ubuntu:latest

RUN apt update
RUN apt install openssh-server sudo -y
RUN apt install socat -y
RUN apt install python3 iproute2 -y

#SSH Setup
RUN mkdir /root/.ssh/
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUPPWxjDCdgIbEQy1WPtl14mMOuVSylF9Mp2H5AsmvJWHvXx8Dpz9tg6Ktj2PV1EISf5LfG8EEMTV6lscbwpjOJdo35y6HPJ16v/dJsoT0zhAX++hp5nbIhXeqCdrdrKbggmstGrJisMtilLpCOM3eNdgDE5zOGyKCYcRxjErUihCfpc1Pk67jPjdpcSk0MUl7jBRTblc0hNgOoAMl0LVNGOLiWrVCwpCPej4CSpycuYrLTA8kAp8anMbj+HYhkwv9Bltw1gIewYcRXR1bOXRvFaUdXPdB0KPIjQXAzwduSt1/RNLc3wEu5pzo6O8cs7rLV+n/fEJY6r/5K6Jgioo/ root@b1552bacb1b4" >> /root/.ssh/authorized_keys
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN service ssh start

WORKDIR /app
COPY server.py ./
COPY startup.sh ./
RUN chmod +x /app/startup.sh
CMD ["/app/startup.sh"]

 
