set -o errexit

# JS & CSS ビルド
yarn build
yarn build:css

# Rails のアセットとDB準備
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed