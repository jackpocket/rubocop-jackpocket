# frozen_string_literal: true

require_relative 'lib/rubocop/jackpocket/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-jackpocket'
  spec.version = RuboCop::Jackpocket::VERSION
  spec.authors = ['Javier Julio']
  spec.email = 'j.julio@draftkings.com'
  spec.summary = 'RuboCop Jackpocket'
  spec.description = "Code style checking for Jackpocket's Ruby projects."
  spec.homepage = 'https://github.com/jackpocket/rubocop-jackpocket'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'
  spec.files = Dir['README.md', 'LICENSE.txt', 'config/*.yml', 'lib/**/*.rb']
  spec.add_dependency 'rubocop'
end
