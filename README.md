# AwesomeFluentLogger

[![Gem Version](https://badge.fury.io/rb/awesome_fluent_logger.svg)](https://rubygems.org/gems/awesome_fluent_logger)

This library can mimic Ruby's built-in Logger class to forward logs to Fluentd. You can use this library not only for Rails but also for pure-Ruby apps.

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
config.logger = ActiveSupport::TaggedLogging.new(logger)
```

### Can be set fluent-logger instance in initialize parameters

`fluent` of initialize argument can be set an instance of [fluent-logger](https://github.com/fluent/fluent-logger-ruby)

```ruby
fluent = Fluent::Logger.new(nil, host: 'localhost', port: 24224)
logger = AwesomeFluentLogger.new(fluent: fluent)
```

### Fluent tags

If the initialize parameter `[:fluent][:tag_prefix]` is specified, it will be inserted at the beginning of the Fluentd tag.

```ruby
logger = AwesomeFluentLogger.new(fluent: { tag_prefix: 'kanan', host: 'localhost', port: 24224 })
logger.info('ご機嫌いかがかなん？')
```

```
2021-01-23 13:28:46.000000000 +0000 kanan.info: {"severity":"INFO", ...
```

The same effect is given by specifying `progname`.

```ruby
logger = AwesomeFluentLogger.new(fluent: { host: 'localhost', port: 24224 }, progname: 'chika')
logger.info('かんかんみかん')
```

```
2021-01-23 13:28:46.000000000 +0000 chika.info: {"severity":"INFO", ...
```

If both are specified, they will be nested. In this case, tag_prefix will be added first.

```ruby
logger = AwesomeFluentLogger.new(fluent: { tag_prefix: 'kanan', host: 'localhost', port: 24224 }, progname: 'chika')
logger.info('2人は幼馴染です')
```

```
2021-01-23 13:28:46.000000000 +0000 kanan.chika.info: {"severity":"INFO", ...
```

### Initialize parameters

Other initialization parameters are based on the Logger class of the Ruby standard library.

| key | default | example |
|:---:|:----:|:-----|
| `fluent` | `nil` | `{host: 'localhost', port: 24224}` or Fluent::Logger::FluentLogger instance |
| `level` | `Logger::DEBUG` | `Logger::INFO` |
| `progname` | `nil` | |
| `formatter` | `nil` | Logger::Formatter type class instance |
| `datetime_format` | `nil` | '%iso8601' or [`Time#strftime` format](https://docs.ruby-lang.org/en/master/Time.html#method-i-strftime) |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/awesome_fluent_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/awesome_fluent_logger/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
