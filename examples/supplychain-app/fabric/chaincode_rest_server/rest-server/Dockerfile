FROM node:8-stretch

COPY . ./app
WORKDIR /app

RUN yarn install
RUN yarn build

ENV PORT 8000
EXPOSE 8000

# Check container health by running a command inside the container
HEALTHCHECK --interval=5s \
            --timeout=5s \
            --retries=6 \
            CMD curl -fs http://localhost:$APP_PORT/ || exit 1

CMD ["yarn", "start"]
