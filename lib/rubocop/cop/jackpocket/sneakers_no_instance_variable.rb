# frozen_string_literal: true

module RuboCop
  module Cop
    module Jackpocket
      class SneakersNoInstanceVariable < SneakersBase
        MSG = 'Do not use instance variables in Sneakers classes.'

        def on_ivar(node)
          return unless in_sneakers_worker?(node)

          add_offense(node)
        end

        def on_ivasgn(node)
          return unless in_sneakers_worker?(node)

          add_offense(node.loc.name)
        end

        private

        def in_sneakers_worker?(node)
          node.each_ancestor(:class, :block).detect { |anc| sneakers_worker?(anc) }
        end
      end
    end
  end
end
