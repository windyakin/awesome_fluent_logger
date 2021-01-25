# AwesomeFluentLogger

[![Gem Version](https://img.shields.io/gem/v/awesome_fluent_logger.svg?color=orange&logo=rubygems)](https://rubygems.org/gems/awesome_fluent_logger)
![ci](https://github.com/windyakin/awesome_fluent_logger/workflows/ci/badge.svg)

This library can mimic Ruby's built-in Logger class to forward logs to Fluentd. You can use this library not only for Rails but also for pure-Ruby apps.

Commentary: [シンプルに Fluentd にログ転送ができる RubyGem "awesome_fluent_logger" をつくった](https://windyakin.hateblo.jp/entry/2021/01/24/143242) (日本語/Japanese)

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

`:fluent` of initialize argument can be set an instance of [Fluent::Logger::FluentLogger](https://github.com/fluent/fluent-logger-ruby) class.

```ruby
fluent = Fluent::Logger::FluentLogger.new(nil, socket_path: '/tmp/fluent.sock')
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

| Key | Default | Descriptions |
|:---|:---|:---|
| `fluent` | (none) | `Fluent::Logger::FluentLogger` initialize paramater hash or `Fluent::Logger::FluentLogger` class instance |
| `level` | `Logger::DEBUG` | [Logger severity level constant](https://docs.ruby-lang.org/en/master/Logger.html) |
| `progname` | `nil` | Program name to include in log messages **and Fluentd tag** |
| `formatter` | [`AwesomeFluentLogger::Formatter`](lib/awesome_fluent_logger/formatter.rb) | Inherited `Logger::Formatter` class instance |
| `datetime_format` | `%Y-%m-%d %H:%M:%S.%6N %z` | `%iso8601` or [`Time#strftime` formatted text](https://docs.ruby-lang.org/en/master/Time.html#method-i-strftime) |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/awesome_fluent_logger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/awesome_fluent_logger/blob/master/CODE_OF_CONDUCT.md).


## License

[MIT License](LICENSE.txt)
