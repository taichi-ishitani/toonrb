# frozen_string_literal: true

if ENV.key?('COVERAGE')
  require 'simplecov'
  SimpleCov.start

  if ENV.key?('CI')
    require 'simplecov-cobertura'
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end
end
