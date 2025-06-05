#!/usr/bin/env bash
set -o errexit

# Node.js の依存関係を先にインストールしておく（安全策）
yarn install --frozen-lockfile

# JS & CSS ビルド
yarn build
yarn build:css

# Rails の依存関係とアセット & DB
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed