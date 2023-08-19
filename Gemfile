source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"

gem "pg", "~> 1.1"
gem "puma", "~> 5.0"

gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

gem "redis", "~> 4.0"
# gem "kredis"

gem "sidekiq", "<7"
gem "sidekiq-scheduler"

gem "devise"
gem "devise-jwt"
gem "activeadmin"
gem "image_processing"

gem "pundit"
gem "acts_as_votable"
gem "counter_culture"
gem "active_storage_validations"
gem "pagy"
# gem "friendly_id"
gem "sendgrid-actionmailer"
gem "aws-sdk-s3", require: false

gem "jbuilder"
# gem "sassc-rails"

gem "googleauth"
gem "omniauth-google-oauth2"
gem "time_difference"
gem "city-state"
gem "country_select", "~> 8.0"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "sqlite3"
end

group :development do
  # gem "rack-mini-profiler"
  # gem "spring"
  gem "web-console"
  gem "figaro"
  gem "bullet"
  gem "faker"
  gem "annotate"
  gem "rubocop-rails"
  gem "rubocop-discourse"
end

group :test do
  gem "capybara"
  gem "letter_opener"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "database_cleaner"
  gem "database_cleaner-active_record"
end
