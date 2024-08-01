# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'

# Use sqlite3 as the database for Active Record
# gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors'

gem 'devise', '~> 4.9', '>= 4.9.4'
gem 'devise_token_auth'
gem 'pg', '>= 0.18', '< 2.0'
gem 'will_paginate', '~> 4.0'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]

  gem 'dotenv-rails', require: 'dotenv/load'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'pry', '~> 0.14.2'
  gem 'rails-controller-testing'
  gem 'rspec', '~> 3.12'
  gem 'rspec-rails', '~> 6.0', '>= 6.0.3'
  gem 'shoulda-matchers', '~> 6.0'

  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'annotate', '~> 3.0', '>= 3.0.3'
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'simplecov', '~> 0.21.2'
end