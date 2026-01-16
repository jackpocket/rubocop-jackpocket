RSpec.describe RuboCop::Cop::Jackpocket::NoBugsnagNotify do
  subject(:cop) { described_class.new }

  context 'with no Bugsnag reference' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class SampleClass
          def testing(message)
          end
        end
      RUBY
    end

    it 'does not register an offense when using ErrorReporter' do
      expect_no_offenses(<<~RUBY)
        class SampleClass
          def testing(message)
            ErrorReporter.report_error(StandardError.new("An error occurred"))
          end
        end
      RUBY
    end

    it 'does not register an offense with partial name' do
      expect_no_offenses(<<~RUBY)
        module BugsnagUserInfo
          extend ActiveSupport::Concern

          included do
            before_bugsnag_notify :add_bugsnag_user_info
          end

          private

          def add_bugsnag_user_info(report)
            report.add_metadata(:user, { id: current_user.id }) if current_user
          end
        end
      RUBY
    end
  end

  context 'with Bugsnag class reference' do
    it 'registers an offense when Bugsnag class is referenced' do
      expect_offense(<<~RUBY)
        class SampleClass
          def testing(message)
            Bugsnag
            ^^^^^^^ Jackpocket/NoBugsnagNotify: Referencing `Bugsnag` is not allowed. Use the `ErrorReporter` class.
          end
        end
      RUBY
    end

    it 'registers an offense when Bugsnag class is referenced' do
      expect_offense(<<~RUBY)
        class SampleClass
          def testing(message)
            Bugsnag
            ^^^^^^^ Jackpocket/NoBugsnagNotify: Referencing `Bugsnag` is not allowed. Use the `ErrorReporter` class.
            count = 1
          end
        end
      RUBY
    end
  end

  context 'with Bugsnag.notify reference' do
    it 'registers an offense when Bugsnag.notify is used' do
      expect_offense(<<~RUBY)
        class SampleClass
          def testing(message)
            Bugsnag.notify(StandardError.new("An error occurred"))
            ^^^^^^^ Jackpocket/NoBugsnagNotify: Referencing `Bugsnag` is not allowed. Use the `ErrorReporter` class.
          end
        end
      RUBY
    end
  end
end
