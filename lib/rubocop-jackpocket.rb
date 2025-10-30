# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/jackpocket'
require_relative 'rubocop/jackpocket/version'
require_relative 'rubocop/jackpocket/inject'

RuboCop::Jackpocket::Inject.defaults!

require_relative 'rubocop/cop/jackpocket/sneakers_base'
require_relative 'rubocop/cop/jackpocket_cops'
