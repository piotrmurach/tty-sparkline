<div align="center">
  <a href="https://ttytoolkit.org"><img width="130" src="https://github.com/piotrmurach/tty/raw/master/images/tty.png" alt="TTY Toolkit logo" /></a>
</div>

# TTY::Sparkline

[![Gem Version](https://badge.fury.io/rb/tty-sparkline.svg)][gem]
[![Actions CI](https://github.com/piotrmurach/tty-sparkline/workflows/CI/badge.svg?branch=master)][gh_actions_ci]
[![Build status](https://ci.appveyor.com/api/projects/status/3pk69ulk2fs330ja?svg=true)][appveyor]
[![Maintainability](https://api.codeclimate.com/v1/badges/aade5679e021d0ca5b55/maintainability)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/github/piotrmurach/tty-sparkline/badge.svg)][coverage]
[![Inline docs](https://inch-ci.org/github/piotrmurach/tty-sparkline.svg?branch=master)][inchpages]

[gem]: https://badge.fury.io/rb/tty-sparkline
[gh_actions_ci]: https://github.com/piotrmurach/tty-sparkline/actions?query=workflow%3ACI
[appveyor]: https://ci.appveyor.com/project/piotrmurach/tty-sparkline
[codeclimate]: https://codeclimate.com/github/piotrmurach/tty-sparkline/maintainability
[coverage]: https://coveralls.io/github/piotrmurach/tty-sparkline
[inchpages]: https://inch-ci.org/github/piotrmurach/tty-sparkline

> Sparkline charts for terminal applications.

**TTY::Sparkline** provides sparkline drawing component for [TTY](https://github.com/piotrmurach/tty) toolkit.

![tty-sparkline](https://github.com/piotrmurach/tty-sparkline/raw/master/assets/tty-sparkline.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "tty-sparkline"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tty-sparkline

## Contents

* [1. Usage](#1-usage)
* [2. Interface](#2-interface)
  * [2.1 new](#21-new)
  * [2.2 append](#22-append)
  * [2.3 render](#23-render)
* [3. Configuration](#3-configuration)
  * [3.1 :top](#31-top)
  * [3.2 :left](#32-left)
  * [3.3 :height](#33-height)
  * [3.4 :width](#34-width)
  * [3.5 :min](#35-min)
  * [3.6 :max](#36-max)
  * [3.7 :bars](#37-bars)
  * [3.8 :buffer_size](#38-buffer_size)
  * [3.9 :non_numeric](#39-non_numeric)

## 1. Usage

To display a sparkline chart, first, create an instance with some data:

```ruby
sparkline = TTY::Sparkline.new(1..8)
```

Then invoke `render` to generate the chart:

```ruby
sparkline.render
# => "▁▂▃▄▅▆▇█"
```

To display the sparkline in the terminal, print it like so:

```ruby
print sparkline.render
```

This will result in the following output:

```
▁▂▃▄▅▆▇█
```

A sparkline can be positioned anywhere within the terminal screen using [:top](#31-top) and [:left](#32-left) keywords:

```ruby
sparkline = TTY::Sparkline.new(1..8, top: 10, left: 50)
```

A sparkline can have custom size given by the [:height](#33-height) and [:width](#34-width) keywords:

```ruby
sparkline = TTY::Sparkline.new(1..8, height: 5, width: 100)
```

To restrict data values use [:min](#35-min) and [:max](#36-max):

```ruby
sparkline = TTY::Sparkline.new(1..8, min: 0, max: 5)
```

## 2. Interface

### 2.1 new

To render a new sparkline chart, first, create an instance:

```ruby
sparkline = TTY::Sparkline.new
```

If you have a static set of data items you can provide them during initialisation with the `:data` keyword that accepts both `Array` and `Range` types:

```ruby
sparkline = TTY::Sparkline.new(1..8)
sparkline = TTY::Sparkline.new([1, 2, 3, 4, 5, 6, 7, 8])
```

However, if you don't know data upfront you can [append](#22-append) it after instantiation:

```ruby
sparkline << 1 << 2 << 3 << 4
```

### 2.2 append

After a sparkline is created, you can further add more data items using the `push` method:

```ruby
sparkline.push(1).push(2)
sparkline.push(3, 4)
```

The `push` is also aliased as `append` and `<<` operator:

```ruby
sparkline.append(5).append(6)
sparkline << 7 << 8
```

Then calling `render` will result in the following:

```ruby
sparkline.render
# => "▁▂▃▄▅▆▇█"
````

This method is particularly useful if you intend to stream data. When streaming it's advisable to specify the maximum [width](#34-width) and position that the chart is going to span:

```ruby
sparkline = TTY::Sparkline.new(left: 0, top: 0, width: 50)
````

And then you can stream data, for example, from some service like so:

```ruby
loop do
  # fetch next value(s) from another service etc.

  sparkline << value      # send value(s) to the chart
  print sparkline.render  # render the chart out to the console
end
```

### 2.3 render

Once you have a sparkline instance with some data:

```ruby
sparkline = TTY::Sparkline.new(1..8)
```

To show the sparkline chart use the `render` method like so:

```ruby
sparkline.render
# => "▁▂▃▄▅▆▇█"
```

To display the chart in the terminal, you need to print it:

```ruby
print sparkline.render
```

This will result in the following output:

```
▁▂▃▄▅▆▇█
```

The render method also accepts a block that provides access to the current value, bar character, column and row.

For example, to insert a space between each bar, we could do the following:

```ruby
sparkline.render do |val, bar, col, row|
  col == 7 ? bar : "#{bar} "
end
```

That would result in:

```ruby
# => "▁ ▂ ▃ ▄ ▅ ▆ ▇ █"
```

The block form is useful for applying colours, for example, to mark the lowest or the highest value.

For instance, you can use [pastel](https://github.com/piotrmurach/pastel) to colour the maximum cyan, minimum red and all the other bars green:


```ruby
pastel = Pastel.new

sparkline.render do |val, bar, col, row|
  if val == 8
    pastel.cyan(bar)
  elsif val == 1
    pastel.red(bar)
  else
    pastel.green(bar)
  end
end
```

## 3. Configuration

### 3.1 `:top`

By default, a sparkline will not be positioned. To position it against the top of the terminal screen use `:top` keyword. For example, to place a sparkline 10 lines down from the top of the screen do:

```ruby
TTY::Sparkline.new(top: 10)
```

Add [:left](#32-left) to position against the left of the terminal screen.

To dynamically position a sparkline within a terminal window consider using [tty-screen](https://github.com/piotrmurach/tty-screen) for gathering screen size. For example, to centre align against the vertical axis do:

```ruby
TTY::Sparkline.new(top: TTY::Screen.height / 2)
```

### 3.2 `:left`

By default, a sparkline will not be positioned. To position it against the left side of the terminal screen use `:left` keyword. For example, to place a sparkline `50` columns away from the left side of the terminal window do:

```ruby
TTY::Sparkline.new(left: 50)
```

Add [:top](#31-top) to position against the top of the terminal screen.

To dynamically position a sparkline within a terminal window consider using [tty-screen](https://github.com/piotrmurach/tty-screen) for gathering screen size. For example, to centre align against horizontal axis do:

```ruby
TTY::Sparkline.new(left: TTY::Screen.width / 2)
```

### 3.3 `:height`

By default, a sparkline will be rendered within a single terminal line. To change a chart to span more than one line use `:height` keyword. For example to display a sparkline on `3` lines do:

```ruby
TTY::Sparkline.new(1..8, height: 3)
```

Then rendering the sparkline in the console:

```ruby
print sparkline.render
````

We would get the following output:

```
      ▃▆
   ▂▅███
▁▄▇█████
```

### 3.4 `:width`

By default, a sparkline will be rendered in as many terminal columns as there are data items. To restrict the chart to a limited number of columns use the `:width` keyword. For example, to display a sparkline up to a maximum of `5` columns do:

```ruby
TTY::Sparkline.new(1..8, width: 5)
```

Then by rendering the sparkline in the console:

```ruby
print sparkline.render
```

We would generate the following limited output:

```
▄▅▆▇█
```

This option can be combined with the [:height](#33-height):

```ruby
TTY::Sparkline.new(1..8, height: 3, width: 5)
```

The result of rendering the above sparkline would be as follows:

```
   ▃▆
▂▅███
█████
```

### 3.5 `:min`

By default, the minimum value will be calculated from the entire data set. For example, given the following data:

```ruby
sparkline = TTY::Sparkline.new([100, 75, 100, 50, 80])
```

When displayed in the console, you will see the following:

```
█▄█▁▅
```

You will notice that the value of `50` looks like it's almost zero. This is because the sparkline automatically scales bars against the minimum value to make the differences between values more visible.

To change this, you can provide a custom minimum value using the `:min` keyword:

```ruby
sparkline = TTY::Sparkline.new([100, 75, 100, 50, 80], min: 0)
```

This time the display will show `50` as a more prominent value at the cost of making the difference between other values less striking:

```
█▆█▄▆
```

### 3.6 `:max`

By default, the maximum value will be calculated from the entire data set. For example, given the following data:

```ruby
sparkline = TTY::Sparkline.new([100, 75, 300, 50, 80])
```

When displayed in the console, you will see the following:

```
▂▁█▁▁
```

You will notice that the value of `300` makes all the remaining numbers look like insignificant zeros. This is because the sparkline automatically scales bars against the maximum value to make the differences between values more prominent.

To change this, you can provide a custom maximum value using the `:max` keyword:

```ruby
sparkline = TTY::Sparkline.new([100, 75, 300, 50, 80], max: 100)
```

This time the display will limit values and reduce `300` to the height of `100` making all the remaining values more visible.

```
█▄█▁▅
```

### 3.7 `:bars`

There are eight bar types used to display values in a sparkline chart. These can be changed with the `:bars` keyword to a different set of characters:

```ruby
sparkline = TTY::Sparkline.new(1..8, bars: %w[_ - = ^])
```

Then rendering the chart will output:

```ruby
sparkline.render
# => "___--==^"
```

### 3.8 `:buffer_size`

By default, the amount of data values that can be [appended](#22-append) to a sparkline is limited to `16K`. This helps to keep the memory size down when streaming data. You can change it with the `:buffer_size` keyword.

For example, to keep the last 5 data values do:

```ruby
sparkline = TTY::Sparkline.new(buffer_size: 5, min: 0)
```

Then exceeding the number of values:

```ruby
sparkline.push(1, 2, 3, 4, 5, 6, 7, 8)
```

Will cause the render to truncate the output:

```ruby
sparkline.render
# => "▄▅▆▇█"
````

### 3.9 `:non_numeric`

To instruct a sparkline on how to deal with non-numeric data use the `:non_numeric` keyword.

Below are the possible values:

* `:empty` - shows empty spaces (default)
* `:ignore` - skips displaying anything
* `:minimum` - shows the smallest bar

Given data with some non-numeric values like `"foo"`, `nil` and `""`:

```ruby
data = [1, 2, "foo", 4, nil, 6, "", 8]
```

When you don't specify the `:non_numeric` keyword, it will be set to `:empty` by default:

```ruby
sparkline = TTY::Sparkline.new(data)
```

This will then display any non-numeric values as empty spaces:

```ruby
sparkline.render
# => "▁▂ ▄ ▆ █"
```

If you want to ignore displaying any non-numeric values use `:ignore`:

```ruby
sparkline = TTY::Sparkline.new(data, non_numeric: :ignore)
```

When rendered, this will result in:

```ruby
sparkline.render
# => "▁▂▄▆█"
````

You can also convert any non-numeric values to the smallest bar with `:minimum`:

```ruby
sparkline = TTY::Sparkline.new(data, non_numeric: :minimum)
```

This will render the following:

```ruby
sparkline.render
# => "▁▂▁▄▁▆▁█"
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
