# Mumukit::Flow

> An adaptative flow implementation for the Mumuki Platform

This gem implements an adaptative flow - on other ways, it responds to the question _what exercise should come next?_. It does not address other aspects of the platform like code evaluation, submission flow UI or feedback provision.

At glance, it supports four types of flow:

* `forward-flow`: how to get to more advanced exercises:
   * `continue`: go to next exercise
   * `fast-forwad`: go faster to more advanced exercies, by bypassing practice exercises when performing very well
* `backward flow`: how to revist previous exercises.
   * `revisit`: do exercises previously skipped by student
   * `retry`: re-do previously solved exercises that turned to be hard to pass

They are implemented as `Mumukit::Flow::Suggestion`s: `Mumukit::Flow::Suggestion::Continue`, `Mumukit::Flow::Suggestion::FastForward`, `Mumukit::Flow::Suggestion::Revisit` and `Mumukit::Flow::Suggestion::Retry`.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mumuki/mumukit-flow. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mumukit::Flow project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mumuki/mumukit-flow/blob/master/CODE_OF_CONDUCT.md).
