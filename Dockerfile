FROM node:Agent3
FROM centos:7
RUN sudo yum update
RUN sudo yum install -y vim
RUN sudo yum install -y nginx
RUN rm /usr/src/*
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD /usr/sbin/nginx -g "daemon off;"
CMD [ "npm", "start" ]
