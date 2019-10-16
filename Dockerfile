# FROM registry.cn-hangzhou.aliyuncs.com/choerodon-tools/hugo:0.40.3 as builder
# WORKDIR /app
# RUN npm install -g grunt-cli gulp
# COPY . .
# RUN npm install --save-dev toml grunt gulp string html-entities marked gulp-uglify gulp-htmlmin gulp-clean-css gulp-concat path js-yaml
# RUN gulp && grunt index
# RUN hugo
# RUN gulp html

FROM node
EXPOSE 8586

# RUN npm i -g yarn

# COPY --from=builder /app/public /usr/share/nginx/html
# ADD ./html /usr/share/nginx/html

WORKDIR /app
COPY . .

RUN yarn install

CMD yarn install && yarn start

