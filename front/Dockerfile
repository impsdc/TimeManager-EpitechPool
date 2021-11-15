FROM node:14.17.0

RUN npm i -g npm@latest
RUN npm install -g serve
RUN mkdir app
COPY . ./app
COPY .env ./app/.env
WORKDIR /app
RUN npm install
RUN npm run build
EXPOSE 5000
RUN chmod +x ./start.sh
CMD ["./start.sh"]