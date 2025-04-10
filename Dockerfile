# 第一阶段：构建阶段
FROM node:16-alpine AS build
WORKDIR /app
COPY package.json yarn.lock ./
ENV http_proxy=http://host.docker.internal:1080
ENV https_proxy=http://host.docker.internal:1080
RUN yarn install
COPY . .
RUN yarn build

# 第二阶段：运行阶段
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]