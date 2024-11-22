FROM node:16-alpine

COPY . /app/

WORKDIR /app

USER root

RUN npm install

RUN npm run build

CMD ["npm", "start"]