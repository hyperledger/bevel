FROM node:10-alpine

#copy app
COPY . ./app

#Set working directory and copy package files over for
WORKDIR /app

RUN apk update || : && apk add python make build-base

#install dependencies
RUN npm install

#Variables for ENV file
ENV PORT=3000
ENV QUORUM_SERVER="P2P"
ENV GANACHE_SERVER="RPC Address of Quorum node"
ENV PRODUCT_CONTRACT_ADDRESS="Enter address where contract is deployed from"
ENV NODE_IDENTITY="Enter address of an account"
ENV NODE_SUBJECT="node subject"
ENV NODE_ORGANIZATION="node organization"
ENV NODE_ORGANIZATION_UNIT="node organization unit"
ENV PROTOCOL="Consensus mechanism used"

EXPOSE ${PORT}
CMD [ "node", "app.js" ]
