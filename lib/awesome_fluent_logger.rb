require "awesome_fluent_logger/version"
require 'awesome_fluent_logger/logger'
require 'awesome_fluent_logger/formatter'

module AwesomeFluentLogger
  def self.new(**args)
    AwesomeFluentLogger::Logger.new(**args)
  end
  class FluentConnectionError < StandardError; end
end
