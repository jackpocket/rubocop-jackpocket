# frozen_string_literal: true

module RuboCop
  module Cop
    module Jackpocket
      class SneakersBase < Base
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
      end
    end
  end
end
