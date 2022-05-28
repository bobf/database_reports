# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'bootsnap', '~> 1.11'
gem 'importmap-rails', '~> 1.1'
gem 'jbuilder', '~> 2.11'
gem 'orchestration', github: 'bobf/orchestration'
gem 'pg', '~> 1.3'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0'
gem 'redis', '~> 4.0'
gem 'sprockets-rails', '~> 3.4'
gem 'sqlite3', '~> 1.4'
gem 'stimulus-rails', '~> 1.0'
gem 'tailwindcss-rails', '~> 2.0'
gem 'turbo-rails', '~> 1.1'

group :development, :test do
  gem 'debug', '~> 1.5'
  gem 'devpack', '~> 0.4.0'
  gem 'rspec-html', '~> 0.2.8'
  gem 'rspec-rails', '~> 5.1'
  gem 'rubocop', '~> 1.30'
  gem 'rubocop-rails', '~> 2.14'
  gem 'rubocop-rspec', '~> 2.11'
  gem 'strong_versions', '~> 0.4.5'
end

group :development do
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'capybara', '~> 3.37'
  gem 'selenium-webdriver', '~> 4.2'
  gem 'webdrivers', '~> 5.0'
end
