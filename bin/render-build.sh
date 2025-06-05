#!/usr/bin/env bash
set -o errexit

# Install JS dependencies
yarn install --frozen-lockfile

# Use local bin path for JS tools
./node_modules/.bin/esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets --loader:.js=jsx
./node_modules/.bin/tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/application.css --minify

# Install Ruby dependencies and setup app
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed