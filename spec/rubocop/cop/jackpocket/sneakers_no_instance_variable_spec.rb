RSpec.describe RuboCop::Cop::Jackpocket::SneakersNoInstanceVariable do
  subject(:cop) { described_class.new }

  context 'a plain class with a work method' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class TestWorker
          def work(message)
          end
        end
      RUBY
    end
  end

  context 'a plain class with included Sneakers module' do
    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        class TestWorker
          include Sneakers::Worker

          def work(message)
          end
        end
      RUBY
    end
  end

  context 'setting an instance variable' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class TestWorker
          include Sneakers::Worker

          def work(message)
            @name = "value"
            ^^^^^ Jackpocket/SneakersNoInstanceVariable: Do not use instance variables in Sneakers classes.
          end
        end
      RUBY
    end

    it 'registers an offense in another method' do
      expect_offense(<<~RUBY)
        class TestWorker
          include Sneakers::Worker

          def work(message)
            some_method
          end

          def some_method
            @name = "value"
            ^^^^^ Jackpocket/SneakersNoInstanceVariable: Do not use instance variables in Sneakers classes.
          end
        end
      RUBY
    end
  end

  context 'getting an instance variable' do
    it 'registers an offense' do
      expect_offense(<<~RUBY)
        class TestWorker
          include Sneakers::Worker

          def work(message)
            @name = "value"
            ^^^^^ Jackpocket/SneakersNoInstanceVariable: Do not use instance variables in Sneakers classes.
            puts @name
                 ^^^^^ Jackpocket/SneakersNoInstanceVariable: Do not use instance variables in Sneakers classes.
          end
        end
      RUBY
    end

    it 'registers an offense in another method' do
      expect_offense(<<~RUBY)
        class TestWorker
          include Sneakers::Worker

          def work(message)
            @name = "value"
            ^^^^^ Jackpocket/SneakersNoInstanceVariable: Do not use instance variables in Sneakers classes.
            some_method
          end

          def some_method
            @name
            ^^^^^ Jackpocket/SneakersNoInstanceVariable: Do not use instance variables in Sneakers classes.
          end
        end
      RUBY
    end

    it 'registers an offense in a rescue block' do
      expect_offense(<<~RUBY)
        class TestWorker
          include Sneakers::Worker

          def work(message)
            @name = "value"
            ^^^^^ Jackpocket/SneakersNoInstanceVariable: Do not use instance variables in Sneakers classes.
          rescue SomeError => error
            if error.code == 503
              @name
              ^^^^^ Jackpocket/SneakersNoInstanceVariable: Do not use instance variables in Sneakers classes.
            end
          end
        end
      RUBY
    end
  end
end
