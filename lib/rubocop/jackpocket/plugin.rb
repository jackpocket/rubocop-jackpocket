# frozen_string_literal: true

require 'lint_roller'

module RuboCop
  module Jackpocket
    # A plugin that integrates RuboCop Jackpocket with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      # :nocov:
      def about
        LintRoller::About.new(
          name: 'rubocop-jackpocket',
          version: Version::STRING,
          homepage: 'https://github.com/jackpocket/rubocop-jackpocket',
          description: 'Code style checking for Jackpocket Ruby projects.'
        )
      end
      # :nocov:

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        project_root = Pathname.new(__dir__).join('../../..')

        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: project_root.join('config/default.yml')
        )
      end
    end
  end
end
