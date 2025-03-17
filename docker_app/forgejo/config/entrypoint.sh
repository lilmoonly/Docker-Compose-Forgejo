#!/bin/sh

# Insert  app.ini from template
envsubst < /home/forgejo/app/custom/conf/app.ini.template > /home/forgejo/app/custom/conf/app.ini

echo "Ready app.ini:"
cat /home/forgejo/app/custom/conf/app.ini

# Running Forgejo
exec ./gitea web

