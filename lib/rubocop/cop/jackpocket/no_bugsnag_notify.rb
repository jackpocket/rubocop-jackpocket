# frozen_string_literal: true

module RuboCop
  module Cop
    module Jackpocket
      class NoBugsnagNotify < Base
        MSG = "Referencing `Bugsnag` is not allowed. Use the `ErrorReporter` class."

        def on_const(node)
          return unless node.children.last == :Bugsnag

          add_offense(node)
        end
      end
    end
  end
end
