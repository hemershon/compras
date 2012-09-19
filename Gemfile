#!/usr/bin/env ruby
source 'http://rubygems.org'
source 'https://gems.gemfury.com/SEqawpNNEx65yrzYS9p8/'

ruby "1.9.3"

gem 'rails', '3.2.8'

platform :jruby do
  gem 'jruby-openssl', '0.7.4'
  gem 'activerecord-jdbcpostgresql-adapter', '1.2.0'
end

platform :ruby do
  gem 'pg', '0.12.2'
  gem 'puma', '1.6.3', :require => false
end

gem 'activerecord-connections', '0.0.3'

gem 'unico', '1.1.0'
gem 'devise', '2.0.4'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git', :branch => '2.0'

gem 'pdfkit', :git => 'git://github.com/comogo/pdfkit.git'
gem 'wkhtmltopdf-binary', '0.9.9.1'
gem 'simple_form', '2.0.1'
gem 'will_paginate', '3.0.3'

gem 'squeel', '1.0.9'
gem 'carrierwave', '0.6.2'
gem 'awesome_nested_set', '2.1.3'

gem 'mail_validator', '0.2.0'
gem 'cnpj_validator', '0.3.1'
gem 'cpf_validator', '0.2.0'
gem 'mask_validator', '0.2.1'
gem 'validates_timeliness', '3.0.11'

gem 'inherited_resources', '1.3.0'
gem 'has_scope', '0.5.1'
gem 'responders', '0.6.4'
gem 'jbuilder', '0.4.0'

gem 'foreigner', '1.2.1'
gem 'i18n_alchemy', :git => 'git://github.com/carlosantoniodasilva/i18n_alchemy.git'

gem 'enumerate_it', '0.7.16'
gem 'decore', :git => 'git://github.com/nohupbrasil/decore.git'

group :assets do
  gem 'uglifier', '1.2.1'
end

group :production, :staging do
  gem 'sentry-raven', :git => 'git://github.com/coderanger/raven-ruby.git', :require => 'raven'
end

group :development, :test do
  gem 'rspec-rails', '2.11.0'
end

group :development do
  gem 'rails-footnotes', '>= 3.7.5.rc4'
end

group :test do
  gem 'shoulda-matchers', '1.1.0'
  gem 'machinist', '2.0'
  gem 'machinist-caching', '0.0.1'
  gem 'capybara', '1.1.2'
  gem 'database_cleaner', '0.8.0'
  gem 'poltergeist', '0.7.0'
end
