# frozen_string_literal: true

module RuboCop
  module Cop
    module Jackpocket
      class SneakersJobControlSignal < Base
        # Re-purposed the rubocop-sidekiq def_node_matchers for Sneakers since we need
        # to ensure the class has `include Sneakers::Worker` and not just a `work` method.
        # https://github.com/dvandersluis/rubocop-sidekiq/blob/master/lib/rubocop/cop/helpers.rb
        def_node_matcher :sneakers_include?, <<~PATTERN
          (send nil? :include (const (const nil? :Sneakers) :Worker))
        PATTERN

        def_node_matcher :includes_sneakers?, <<~PATTERN
          {
            (begin <#sneakers_include? ...>)
            #sneakers_include?
          }
        PATTERN

        def_node_matcher :sneakers_worker_class_def?, <<~PATTERN
          (class _ _ #includes_sneakers?)
        PATTERN

        def_node_matcher :sneakers_worker_anon_class_def?, <<~PATTERN
          (block (send (const nil? :Class) :new ...) _ #includes_sneakers?)
        PATTERN

        def_node_matcher :sneakers_worker?, <<~PATTERN
          {#sneakers_worker_class_def? #sneakers_worker_anon_class_def?}
        PATTERN

        def_node_matcher :end_with_sneakers_signal?, <<~PATTERN
          (... (send nil? {:ack! :reject! :requeue!}))
        PATTERN

        MSG = 'The `work` method must return `ack!`, `reject!`, or `requeue!`'.freeze

        def on_def(node)
          return unless node.method?(:work) && in_sneakers_worker?(node)

          def_body = node.body

          items = if def_body && def_body.type == :rescue
                    [{ node: node, body: def_body.body }, *resbody_branches_with_node(def_body)]
                  else
                    [{ node: node, body: def_body }]
                  end

          items.each do |item|
            if item[:body].nil? || !end_with_sneakers_signal?(item[:body])
              add_offense(item[:body] || item[:node], message: MSG)
            end
          end
        end

        private

        def in_sneakers_worker?(node)
          node.each_ancestor(:class, :block).detect { |anc| sneakers_worker?(anc) }
        end

        # We want the node and body in case the body is empty. For example,
        # this method body would be `nil`. Same for an empty rescue body.
        #
        # def work(message)
        # end
        #
        # So then on adding an offense we can provide a node in place of
        # the body as the location when the body is empty.
        def resbody_branches_with_node(rescue_body)
          items = rescue_body.resbody_branches.map do |b|
            { node: b, body: b.body }
          end
          items.push({ node: rescue_body.loc.else, body: rescue_body.else_branch }) if rescue_body.else?
          items
        end
      end
    end
  end
end
