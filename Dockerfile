FROM node:16-alpine AS build

WORKDIR /app
COPY . /app

RUN set -ex \
  # Build JS-Application
  && npm install --production \
  # Generate SSL-certificate (for HTTPS)
  # && apk --no-cache add openssl \
  # && sh generate-cert.sh \
  # && apk del openssl \
  # && rm -rf /var/cache/apk/* \
  # Delete unnecessary files
  # && rm package* generate-cert.sh \
  # Correct User's file access
  && chown -R node:node /app 
  #&& chmod +r /app/privkey.pem

FROM node:16-alpine AS final
WORKDIR /app
COPY --from=build /app /app
ENV HTTP_PORT=8080
EXPOSE $HTTP_PORT
USER 1000
CMD ["node", "./index.js"]
