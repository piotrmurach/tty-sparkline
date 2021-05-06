<div align="center">
  <a href="https://ttytoolkit.org"><img width="130" src="https://github.com/piotrmurach/tty/raw/master/images/tty.png" alt="TTY Toolkit logo" /></a>
</div>

# TTY::Sparkline

[![Gem Version](https://badge.fury.io/rb/tty-sparkline.svg)][gem]
[![Actions CI](https://github.com/piotrmurach/tty-sparkline/workflows/CI/badge.svg?branch=master)][gh_actions_ci]
[![Build status](https://ci.appveyor.com/api/projects/status/0dya67sqm0larc2c?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/aade5679e021d0ca5b55/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/tty-sparkline/badge.svg)][coverage]
[![Inline docs](https://inch-ci.org/github/piotrmurach/tty-sparkline.svg?branch=master)][inchpages]

[gem]: https://badge.fury.io/rb/tty-sparkline
[gh_actions_ci]: https://github.com/piotrmurach/tty-sparkline/actions?query=workflow%3ACI
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty-sparkline
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty-sparkline/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/tty-sparkline
[inchpages]: https://inch-ci.org/github/piotrmurach/tty-sparkline

> A sparkline chart for terminal applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tty-sparkline"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tty-sparkline

## Usage

To create a sparkline chart:

```ruby
sparkline = TTY::Sparkline.new
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/piotrmurach/tty-sparkline. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/piotrmurach/tty-sparkline/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TTY::Sparkline project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/piotrmurach/tty-sparkline/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) 2021 Piotr Murach. See LICENSE for further details.
