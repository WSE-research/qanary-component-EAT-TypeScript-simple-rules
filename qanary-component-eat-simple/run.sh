#!/usr/bin/env bash

set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "ROOT_DIR: $ROOT_DIR"
cd "$ROOT_DIR"

if [ -f $ROOT_DIR/.env ]; then
  source $ROOT_DIR/.env
  echo "SPRING_BOOT_ADMIN_URL: $SPRING_BOOT_ADMIN_URL"
  echo "QANARY_HOST: $QANARY_HOST"
  echo "QANARY_PORT: $QANARY_PORT"
else
  echo "Warning: $ROOT_DIR/.env file not found"
fi



# 1) install all required dependencies
echo "Installing dependencies"
npm install --workspaces --include-workspace-root

echo "Building component and dependencies"
npm run build --workspace=api && \
  npm run build --workspace=qanary-component-helpers && \
  npm run build --workspace=shared && \
  npm run build --workspace=qanary-component-core && \
  npm run build --workspace=qanary-component-eat-simple

# build core component
CORE_DIST_ROOT="$ROOT_DIR/packages/qanary-component-core/dist"
if [ -f "$CORE_DIST_ROOT/src/index.js" ] && [ ! -f "$CORE_DIST_ROOT/index.js" ]; then
  echo 'module.exports = require("./src/index.js");' > "$CORE_DIST_ROOT/index.js"
fi
if [ -f "$CORE_DIST_ROOT/src/index.d.ts" ] && [ ! -f "$CORE_DIST_ROOT/index.d.ts" ]; then
  echo 'export * from "./src/index";' > "$CORE_DIST_ROOT/index.d.ts"
fi

if [ ! -f "$ROOT_DIR/packages/qanary-component-core/dist/index.js" ]; then
  npx tsc -p "$ROOT_DIR/packages/qanary-component-core/tsconfig.json" --outDir "$ROOT_DIR/packages/qanary-component-core/dist"
fi

# Ensure runtime resolves workspace packages via NODE_PATH
rm -rf "$ROOT_DIR/node_modules/qanary-component-core" "$ROOT_DIR/node_modules/shared"

# 2) run all tests
echo "Running tests"
npm run test --workspace=qanary-component-eat-simple

# 3) start the application (ts-node runtime)
env "SPRING_BOOT_ADMIN_CLIENT_INSTANCE_SERVICE-BASE-URL=$SPRING_BOOT_ADMIN_URL" \
  "SPRING_BOOT_ADMIN_URL=$SPRING_BOOT_ADMIN_URL" \
  "QANARY_COMPONENT_PACKAGE_JSON=$ROOT_DIR/qanary-component-eat-simple/package.json" \
  "NODE_PATH=$ROOT_DIR/packages" \
  "NODE_OPTIONS=--preserve-symlinks" \
  "SKIP_REGISTRATION=true" \
  "TS_NODE_PROJECT=$ROOT_DIR/qanary-component-eat-simple/tsconfig.json" \
  npx ts-node "$ROOT_DIR/qanary-component-eat-simple/src/index.ts"

