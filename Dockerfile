FROM node:18

WORKDIR /app

COPY . .

RUN npm install newrelic

COPY ./node_modules/newrelic/newrelic.js .

RUN npm install

EXPOSE 3000

CMD ["node", "-r", "newrelic", "index.js"]