# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in toonrb.gemspec
gemspec

group 'development_common' do
  gem 'bundler', require: false
  gem 'racc', require: false
  gem 'rake', require: false
end

group 'development_test' do
  gem 'minitest', '~> 5.16', require: false
end

group 'development_lint' do
  gem 'rubocop', '~> 1.81.1', require: false
end

group 'development_local' do
  gem 'bump', '~> 0.10.0', require: false
  gem 'debug', require: false
  gem 'ruby-lsp', require: false
end
