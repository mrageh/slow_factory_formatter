# SlowFactoryFormatter [ ![Codeship Status for mrageh/slow_factory_formatter](https://codeship.com/projects/a5090710-78c9-0133-0133-4ab273700aba/status?branch=master)](https://codeship.com/projects/118608)

This gem is a custom RSpec formatter that allows you to generate a table of
slow factories when you run your tests.

FactoryBot uses ActiveSupport::Notifications instrumentation api which allows
us track how much time is spent creating factories.

This gem uses that api to display factories that take a long to setup.

My naive definition of a slow factory is any factory that takes more then 0.5
seconds to setup or any factory that creates or builds more then five instances
of itself.  If a factory does either of those things then SlowFactoryFormatter
will generate a table and add that factory as a row to that table.

## Why use SlowFactoryFormatter

[FactoryBot](https://github.com/thoughtbot/factory_bot) allows you to quickly
and painlessly setup factories that you can use in your tests.  You can then use
them in your tests by calling `FactoryBot.(build || create)(:some_factory)`
and create a tree of objects, when really you only meant to create/instantiate
one object for your test. When you try to use a factory that sets up a lot of
objects in a simple test case, you'll end up slowing down your test suite,
unaware that the reason why your test suite has slowed down is because how many
objects are being setup in the background.

This can quickly increase the time it takes a test suite to run and as a team
grows it can really start to slowdown the build.

I've seen projects where one of the main causes of a slow build is the number of
factories being setup in each example group.

The main benefit of using SlowFactoryFormatter is that it will help you identify
the number of objects being setup, when you run a test.

## Installation

This gem is intended to be used on a Rails project and you will need to have
FactoryBot, RSpec version 3.4 or later and ActiveSupport version 3 or
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
| Factory Name                 | Create | Build | Build Stubbed | Total Time           |
+------------------------------+--------+-------+---------------+----------------------+
| user                         | 67     | 2     | 16            | 4.48 seconds         |
| product                      | 45     | 0     | 2             | 1.16 seconds         |
| order                        | 97     | 0     | 0             | 3.66 seconds         |
| admin                        | 49     | 12    | 1             | 3.02 seconds         |
| project                      | 33     | 40    | 34            | 4.33 seconds         |
| customer                     | 88     | 43    | 2             | 6.16 seconds         |
| manager                      | 12     | 23    | 0             | 1.10 seconds         |
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

## Credit

[Michael Baldry](<https://github.com/mikebaldry>) initially introduced me to the
idea of generating a table of slow factories.

[Tom Stuart](<https://github.com/tomstuart>) suggested I turn this into a simple
gem that can be reused on many projects.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mrageh/slow_factory_formatter.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

