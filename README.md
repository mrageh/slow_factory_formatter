# SlowFactoryFormatter

This gem is a custom RSpec formatter that allows you to generate a table of
slow factories when you run your tests.

My naive definition of a slow factory is any factory that takes more then half
a second to setup or any factory that creates or builds more then five instances
of itself.

## Why use SlowFactoryFormatter

[FactoryGirl](https://github.com/thoughtbot/factory_girl) allows you to quickly
and painlessly setup factories that you can use in your tests. The problem with
[FactoryGirl](https://github.com/thoughtbot/factory_girl) is that it makes it
very easy to write your factories in such a way that a valid factory can end up
creating or building a big tree of objects. When you try to use a factory that
sets up a lot of objects in a simple test case, you'll end up slowing down your
test suite, unaware of just how many objects are being setup in the background.

This can quickly increase the time it takes a test suite to run and as a team
grows it can really start to slow the time it takes your build to run.

I've seen projects where one of the main causes of a slow build is the number of
factories being setup in each example group.

The main benefit of using SlowFactoryFormatter is that it will help you identify
the number of objects being setup, when you run a test.

## Installation

This gem is intended to be used on a Rails project and you will need to have
FactoryGirl, RSpec version 3.4 or later and ActiveSupport version 4 or
later in your project.

To use this gem with a Rails project add this line to your Gemfile:

```ruby
group :test do
  gem 'slow_factory_formatter'
end
```

And then run:

    `$ bundle`

Or install it yourself as:

    `$ gem install slow_factory_formatter`

## Usage

You can either use this gem when running `rspec` command:

```
rspec spec/models/user_spec --format SlowFactoryFormatter
```

```
+------------------------------+--------+-------+---------------+----------------------+
|                                    Slow Factories                                    |
+------------------------------+--------+-------+---------------+----------------------+
| Factory Name                 | Create | Build | Build Stubbed | Total Time (in secs) |
+------------------------------+--------+-------+---------------+----------------------+
| user                         | 67     | 2     | 16            | 4.48                 |
| product                      | 45     | 0     | 2             | 1.16                 |
| order                        | 97     | 0     | 0             | 3.66                 |
| admin                        | 49     | 12    | 1             | 3.02                 |
| project                      | 33     | 40    | 34            | 4.33                 |
| customer                     | 88     | 43    | 2             | 6.16                 |
| manager                      | 12     | 23    | 0             | 1.10                 |
+------------------------------+--------+-------+---------------+----------------------+
```

Or if you want to use it every time you run a test in your project, you can add
it to `.rspec` file in the root of your project directory:

```
--format SlowFactoryFormatter
```

This will make SlowFactoryFormatter your default formatter and you'll see a
table similar to the one above of slow factories whenever you run a test, unless
you have no slow factories.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mrageh/slow_factory_formatter.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

