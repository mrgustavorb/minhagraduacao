source 'https://rubygems.org'
ruby "2.1.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'

# Authentication rails
gem 'devise'

# Use postgres as the database for Active Record
gem 'pg'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Manipulate XML
gem 'nokogiri'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.2'

# Config variables file env
gem 'dotenv-rails'
gem 'settingslogic'

# Upload file to S3
gem 'paperclip'
gem "aws-sdk"

# Group gems activerecord
gem 'enumerize'
gem "pundit"
gem 'paranoia', github: 'radar/paranoia', branch: 'rails4'
gem 'pg_search' 

# Group gems backend
gem "wice_grid", '3.4.2'

# Bug track
gem "airbrake"

# Group gems to front-End
gem 'foreman'
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'  
gem 'bootstrap-sass', '~> 3.0.2.1'
gem "font-awesome-rails"
gem "breadcrumbs_on_rails"
gem 'carrierwave', '~> 0.9.0'
gem 'mail_form', '~> 1.5.0'
gem 'simple_form'
gem 'compass'
gem 'compass-rails'
gem 'brazilian-rails'
gem 'meta-tags'
gem 'twitter-typeahead-rails'
gem 'sitemap_generator'
gem 'byebug'
gem 'enumerize'

# Apis
gem 'omniauth'
gem 'omniauth-facebook'

# Group gems to docs
group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Group gems to development
group :development do
  gem 'capistrano', '~> 3.1.0'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rvm', github: "capistrano/rvm"
  gem 'populator'
  gem 'faker'
  gem 'mailcatcher'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'awesome_print'
  gem 'annotate', '~> 2.6.5'
  gem 'xray-rails'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'unicorn'
  gem 'aws-ses'
end
