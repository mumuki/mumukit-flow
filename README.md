# :arrow_right_hook: Mumukit::Flow ![Test and deploy](https://github.com/mumuki/mumukit-flow/workflows/Test%20and%20deploy/badge.svg?branch=master)

> An adaptive flow implementation for the Mumuki Platform

This gem implements an adaptive flow - it considers a student's performance to respond to the question _what exercise should come next?_. It does not address other aspects of the platform like code evaluation, submission flow UI or feedback provision, but it does implement some navigation-related aspects.

The initial work on this gem is based on Marco Moresi's Computer Science Thesis from the Faculty of Mathematics, Algebra and Physics, University of Córdoba, Argentina, which can be found in [this repository](https://github.com/mrcmoresi/msc-thesis).


## Introduction

A standard Mumuki lesson has `n + m` exercises, where `n` is the minimum number of exercises that cover all theoretical concepts and `m` is a differential that adds practice without introducing any new concepts. The idea of adaptive flow is to know when to present one of these exercises to the student when some exercise is difficult.

## Previous definitions

### Exercise concepts

When the student shows difficulty in an exercise `n`, it is necessary to have a minimum notion regarding which concepts that exercise develops. With this information, an exercise can be presented that exercises or reinforces these concepts. How can it be done?

* By exercise: Let an exercise `m` know which exercises `n` reinforces
* By concept: Let an exercise `m` exercise have one or more tags - labels - that indicate which concepts are worked on. **This is the approach `flow` currently takes**
* By mistake: Depending on the error that gives - or the expectation that does not pass - the exercise `n`, know which is the concept that fails, and propose an exercise m that works on that error or expectation. Probably the best of the three, but the hardest at the same time.


### Difficulty identification

And how do we know that a student shows difficulty - or _"hangs"_ - in an exercise or lesson?

* It takes a long time to send a solution: Difficult to quantify because there are tons of reasons why you may interrupt your session in order to do something else. Just because it's late to submit doesn't mean you've been paying attention the entire time between opening the exercise and hitting Submit.
* You make successive mistakes when sending a solution: For some reason he cannot pass - as in `passed` - an exercise, or has many failed attempts before he succeeds. That number of attempts is to be determined.
* You make successive mistakes when sending several solutions: Like the previous case, but taking into account multiple exercises. In this way, we do not immediately resort to suggesting an exercise m

**`flow` does not currently answer this question.**

## Suggestions

At a glance, `flow` supports five types of suggestions:

 * :arrow_forward:  `continue`: go to the next exercise
 * :arrow_backward:  `revisit`: try again an exercise the student manually skipped
 * :fast_forward: `skip`: go faster to more advanced exercises by skipping practice exercises when performing very well
 * :rewind: `reinforce`: go to an easier exercise, to better grasp the concepts that prove difficult for the student
 * :stop_button: `none`: nothing to suggest


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
