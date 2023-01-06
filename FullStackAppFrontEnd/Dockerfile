FROM node:14-slim AS builder 
#directory we are operating from
WORKDIR /app
COPY ./package.json ./
RUN npm i
COPY . .
#because we are using Nginx we need to make a build folder 
#the build directory contains the files our front end depends on
#when our app is on a virtual machine 
RUN npm run build

FROM nginx
#routes in our app are handled inside the config file
#we must remove the default config file in the nginx 
#directory of this image and copy our config file into it
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/
#the /usr/share/nginx/html directory contains the files 
#nginx shows when viewing the application on a browser 
COPY --from=builder /app/build /usr/share/nginx/html