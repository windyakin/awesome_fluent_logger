# AwesomeFluentLogger

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/awesome_fluent_logger`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'awesome_fluent_logger'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install awesome_fluent_logger
```

## Usage

### Tiny example

Your Ruby program:

```ruby
require 'awesome_fluent_logger'

logger = AwesomeFluentLogger.new(fluent: { host: 'localhost', port: 24224 })
logger.info('information logging')
```

Fluentd output:

```
2021-01-23 13:28:46.000000000 +0000 info: {"severity":"INFO","time":"2021-01-23 13:28:46.336397 +0000","progname":null,"message":"information logging"}
```

### Rails example

Rails configure file (`config/application.rb` or `config/environments/{RAILS_ENV}.rb`):

```ruby
logger = AwesomeFluentLogger.new(fluent: { host: 'localhost', port: 24224 })
config.logger = ActiveSupport::TaggedLogging(logger)
```

### Set fluent-logger instance

`fluent` of initialize argument can be passed an instance of [fluent-logger](https://github.com/fluent/fluent-logger-ruby)

```ruby
fluent = Fluent::Logger.new(nil, host: 'localhost', port: 24224)
logger = AwesomeFluentLogger.new(fluent: fluent)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/awesome_fluent_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/awesome_fluent_logger/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
