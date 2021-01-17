# frozen_string_literal: true

require 'fluent-logger'
require 'awesome_fluent_logger/formatter'

module AwesomeFluentLogger
  class Logger < ::Logger
    def initialize(logger, level: DEBUG, progname: nil, formatter: nil, datetime_format: nil, tag: nil)
      super(nil, 0, 0, level: level, progname: progname, formatter: formatter, datetime_format: datetime_format)
      raise ArgumentError unless logger.respond_to?(:post)
      raise FluentConnectionError unless logger.connect?
      @logger = logger
      @default_formatter = Formatter.new
      @tag = tag || progname
    end

    def add(severity, message = nil, progname = nil)
      severity ||= UNKNOWN

      if @logger.nil? or severity < level
        return true
      end

      if progname.nil?
        progname = @progname
      end
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end

      @logger.post(@tag, format_message(format_severity(severity), Time.now, progname, message))
      true
    end

    def <<(msg)
      @logger&.post(@tag, msg)
    end

    def close
      @logger&.close
    end
  end
end