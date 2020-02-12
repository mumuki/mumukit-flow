# Mumukit::Flow

> An adaptive flow implementation for the Mumuki Platform

This gem implements an adaptive flow - it considers a student's performance to respond to the question _what exercise should come next?_. It does not address other aspects of the platform like code evaluation, submission flow UI or feedback provision, but it does implement some navigation-related aspects.

The initial work on this gem is based on Marco Moresi's Computer Science Thesis from the Faculty of Mathematics, Algebra and Physics, University of Córdoba, Argentina, which can be found in [this repository](https://github.com/mrcmoresi/msc-thesis).

At a glance, it supports five types of suggestions:

 * `continue`: go to the next exercise
 * `revisit`: try again an exercise the student manually skipped
 * `skip`: go faster to more advanced exercises by skipping practice exercises when performing very well
 * `reinforce`: go to an easier exercise, to better grasp the concepts that prove difficult for the student
 * `none`: nothing to suggest
 
They are implemented as `Mumukit::Flow::Suggestion`s: `Mumukit::Flow::Suggestion::Continue`, `Mumukit::Flow::Suggestion::Revisit`, `Mumukit::Flow::Suggestion::Skip`, `Mumukit::Flow::Suggestion::Reinforce` and `Mumukit::Flow::Suggestion::None`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mumuki/mumukit-flow. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mumukit::Flow project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mumuki/mumukit-flow/blob/master/CODE_OF_CONDUCT.md).
