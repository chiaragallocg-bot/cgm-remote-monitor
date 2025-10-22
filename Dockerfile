FROM node:16.16.0-alpine

LABEL maintainer="Nightscout Contributors"

WORKDIR /opt/app
ADD . /opt/app

# TODO: We should be able to do `RUN npm install --only=production`.
# For this to work, we need to copy only package.json and things needed for `npm`'s to succeed.
# TODO: Do we need to re-add `npm audit fix`? Or should that be part of a development process/stage?
RUN npm install --cache /tmp/empty-cache && \
    npm run postinstall && \
    npm run env && \
    rm -rf /tmp/*

# Set working directory and expose correct port
USER node
EXPOSE 8080

# Start Nightscout explicitly on the Render port
CMD ["sh", "-c", "node lib/server/server.js --port ${PORT:-8080}"]
