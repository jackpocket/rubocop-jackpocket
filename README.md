# RuboCop Jackpocket

Custom Rubocop cops for Jackpocket's Ruby projects.

## Usage

Add `rubocop-jackpocket` to your Gemfile.

## Development

Run `bundle install` and then `bundle exec rspec` for setup.

Generate a new cop with `bin/new-cop Jackpocket/MyCustomCop`.

All custom cops are located under [`lib/rubocop/cop/jackpocket`](lib/rubocop/cop/jackpocket).

## Releases

1. Run `git checkout master && git fetch origin && git rebase origin/master`
2. Bump the version in `lib/rubocop/jackpocket/version.rb`
3. Run `bundle install` to update gemspec version
4. Use that version in: `git tag -a "v0.0.0" -m "Version 0.0.0"`
5. Then run: `git push --tags`

## Resources

- https://github.com/dvandersluis/rubocop-sidekiq
- https://github.com/rubocop/rubocop/blob/master/lib/rubocop/cop/style/return_nil_in_predicate_method_definition.rb#L94-L101
- https://github.com/rubocop/rubocop-ast/blob/master/lib/rubocop/ast/node/rescue_node.rb
- https://github.com/rubocop/rubocop-ast/blob/master/lib/rubocop/ast/node/mixin/descendence.rb
- https://stackoverflow.com/a/60860385
