RSpec.describe RuboCop::Cop::Jackpocket::SneakersJobControlSignal do
  subject(:cop) { described_class.new }

  context "a plain class with a work method" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY)
        class TestWorker
          def work(message)
          end
        end
      RUBY
    end
  end

  [:ack!, :reject!, :requeue!].each do |signal_name|
    describe "##{signal_name}" do
      context "as last line in method" do
        it "does not register an offense" do
          expect_no_offenses(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
                do_something
                #{signal_name}
              end
            end
          RUBY
        end
      end

      context "as last line in method and rescue" do
        it "does not register an offense" do
          expect_no_offenses(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
                do_something
                #{signal_name}
              rescue SomeError
                handle_error
                #{signal_name}
              end
            end
          RUBY
        end
      end

      context "as last line in method, rescue and else" do
        it "does not register an offense" do
          expect_no_offenses(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
                do_something
                #{signal_name}
              rescue SomeError
                handle_error
                #{signal_name}
              else
                do_else
                #{signal_name}
              end
            end
          RUBY
        end
      end

      context "with an empty method" do
        it "registers an offense" do
          expect_offense(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
              ^^^^^^^^^^^^^^^^^ Jackpocket/SneakersJobControlSignal: The last line in `work` method must be `ack!`, `reject!`, or `requeue!`
              end
            end
          RUBY
        end
      end

      context "with an empty rescue" do
        it "registers an offense" do
          expect_offense(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
                do_something
                #{signal_name}
              rescue SomeError
              ^^^^^^^^^^^^^^^^ Jackpocket/SneakersJobControlSignal: The last line in `work` method must be `ack!`, `reject!`, or `requeue!`
              end
            end
          RUBY
        end
      end

      context "with a method and rescue" do
        it "registers an offense" do
          expect_offense(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
                do_something
                ^^^^^^^^^^^^ Jackpocket/SneakersJobControlSignal: The last line in `work` method must be `ack!`, `reject!`, or `requeue!`
              rescue SomeError
                handle_error
                ^^^^^^^^^^^^ Jackpocket/SneakersJobControlSignal: The last line in `work` method must be `ack!`, `reject!`, or `requeue!`
              end
            end
          RUBY
        end
      end

      context "with a method, rescue and else" do
        it "registers an offense" do
          expect_offense(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
                do_something
                #{signal_name}
              rescue SomeError
                handle_error
                #{signal_name}
              else
                do_else
                ^^^^^^^ Jackpocket/SneakersJobControlSignal: The last line in `work` method must be `ack!`, `reject!`, or `requeue!`
              end
            end
          RUBY
        end

        it "registers an offense" do
          expect_offense(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
                do_something
                #{signal_name}
              rescue SomeError
                handle_error
                ^^^^^^^^^^^^ Jackpocket/SneakersJobControlSignal: The last line in `work` method must be `ack!`, `reject!`, or `requeue!`
              else
                do_else
                #{signal_name}
              end
            end
          RUBY
        end

        it "registers an offense" do
          expect_offense(<<~RUBY)
            class TestWorker
              include Sneakers::Worker

              def work(message)
                do_something
                #{signal_name}
              rescue SomeError
                handle_error
                ^^^^^^^^^^^^ Jackpocket/SneakersJobControlSignal: The last line in `work` method must be `ack!`, `reject!`, or `requeue!`
              else
                do_else
                ^^^^^^^ Jackpocket/SneakersJobControlSignal: The last line in `work` method must be `ack!`, `reject!`, or `requeue!`
              end
            end
          RUBY
        end
      end
    end
  end
end
