TOURISM_API_URL=$1
TOURISM_WSS_URL=$2
set -e
cd app || exit
export API_HOST=${TOURISM_API_URL}
export WSS_HOST=${TOURISM_WSS_URL}
envsubst < environment.ts.template > ./src/env/environment.ts || exit
npm run build
cd dist && mv "$(find . -maxdepth 1 -type d | tail -n 1)" /app