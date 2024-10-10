# FROM node:20-alpine AS base

# WORKDIR /usr/src/app

# COPY package*.json ./

# RUN npm install

# FROM base AS build

# COPY . .

# RUN npm run build && npm prune --production

# FROM node:20-alpine AS deploy

# WORKDIR /usr/src/app

# RUN npm install -g prisma

# COPY --from=build /usr/src/app/dist ./dist
# COPY --from=build /usr/src/app/node_modules ./node_modules
# COPY --from=build /usr/src/app/package.json ./package.json
# COPY --from=build /usr/src/app/prisma ./prisma

# RUN prisma generate

# EXPOSE 3333

# CMD [ "npm", "start" ]

## imagem que eu fiz

FROM node:20.17 AS base

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

FROM base AS build

COPY . .
COPY --from=base /usr/src/app/node_modules ./node_modules

RUN npm run build
RUN npm prune --production

FROM node:20.17-alpine3.19 AS deploy

WORKDIR /usr/src/app

RUN npm install -g prisma

ENV DATABASE_URL=postgresql://passin_owner:cbh91CTaGovA@ep-quiet-snow-a5xshgy8.us-east-2.aws.neon.tech/passin?sslmode=require

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/prisma ./prisma

RUN prisma generate

EXPOSE 3333

CMD [ "npm", "start" ]

## exmpleo rocketseat com npm

# FROM node:20 AS base

# FROM base AS dependencies

# WORKDIR /usr/src/app

# COPY package.json package-lock.json ./

# RUN npm install

# FROM base AS build

# WORKDIR /usr/src/app

# COPY . .

# COPY --from=dependencies /usr/src/app/node_modules ./node_modules

# RUN npm run build
# RUN npm prune --production

# FROM node:20-alpine3.19 AS deploy

# WORKDIR /usr/src/app

# RUN npm install -g prisma

# COPY --from=build /usr/src/app/dist ./dist
# COPY --from=build /usr/src/app/node_modules ./node_modules
# COPY --from=build /usr/src/app/package.json ./package.json
# COPY --from=build /usr/src/app/prisma ./prisma

# RUN prisma generate

# EXPOSE 3333

# CMD [ "npm", "start" ]