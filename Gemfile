#!/usr/bin/env ruby
source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '3.2.22.2'
gem 'sidekiq'

gem 'pg'

gem 'activerecord-connections', '0.0.3'
gem 'activerecord-postgres-hstore'

source 'http://foo:BringMeSomeBeerNow@devops.nobesistemas.com.br:9292/' do
  gem 'unico', '6.4.8rmagick'
  gem 'unico-assets', '1.5.4'
  gem 'unico-api', '1.6.0'
  gem 'quaestio', '0.1.1'
  gem 'active_relatus'
end

gem 'devise', '2.2.4'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git', :branch => '2.0'

gem 'wkhtmltopdf-binary', '0.9.9.1'
gem 'simple_form', '2.1.0'
gem 'kaminari', '0.14.1'

gem 'squeel'
gem 'carrierwave'
gem 'awesome_nested_set'

gem 'cnpj_validator', '0.3.1'
gem 'cpf_validator', '0.2.0'
gem 'mask_validator', '0.2.1'
gem 'validates_timeliness', '3.0.14'
gem 'typecaster', '0.0.2', :git => 'git://github.com/ricardohsd/typecaster'
gem 'rubyzip', '0.9.9'

gem 'inherited_resources', '1.4.0'
gem 'has_scope', '0.5.1'
gem 'responders', '0.9.3'
gem 'jbuilder'

gem 'foreigner'
gem 'i18n_alchemy', :git => 'git://github.com/carlosantoniodasilva/i18n_alchemy.git'

gem 'enumerate_it'
gem 'decore', :git => 'git://github.com/sobrinho/decore.git'

gem 'strong_parameters', '0.2.1'

group :assets do
  gem 'uglifier'
end

group :production, :training, :staging do
  gem 'dalli', '2.6.4'
end

gem 'sentry-raven'

group :development, :test do
  gem 'unicorn', '4.6.2'
  gem 'factory_girl-preload', :git => 'git://github.com/MarceloCajueiro/factory_girl-preload.git'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'postgres-copy'
  gem 'pry'
  gem 'pry-remote'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara', '2.1.0'
  gem 'capybara-webkit'
  gem 'machinist', '2.0'
  gem 'machinist-caching', '0.0.1'
  gem 'selenium-webdriver', '~> 2.33.0'
  gem 'shoulda-matchers', '2.2.0'
  gem 'simplecov', :require => false
  gem 'vcr', '=2.5.0'
  gem 'fakeweb'
  gem 'timecop'
end
