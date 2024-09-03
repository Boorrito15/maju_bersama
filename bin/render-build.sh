#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Ruby dependencies
bundle install

# Install JavaScript dependencies
npm install # or npm install, depending on your setup

# Precompile assets (which includes running vite:build)
bundle exec rails assets:precompile

# Clean up old assets (optional)
# bundle exec rails assets:clean

# Run database migrations (if needed)
bundle exec rails db:migrate
