# frozen_string_literal: true

require 'fluent-logger'
require 'logger'

module AwesomeFluentLogger
  class Logger < ::Logger
    attr_reader :logger
    def initialize(fluent: nil, level: DEBUG, progname: nil, formatter: nil, datetime_format: nil)
      super(nil, 0, 0, level: level, progname: progname, formatter: formatter, datetime_format: datetime_format)
      if fluent.is_a?(Hash)
        @logger = ::Fluent::Logger::FluentLogger.new(fluent[:tag_prefix], **fluent)
      elsif fluent.respond_to?(:post)
        @logger = logger
      else
        raise ArgumentError
      end
      @default_formatter = Formatter.new
      @default_formatter.datetime_format = datetime_format
      @tag = fluent[:tag_prefix] || progname
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

      data = format_message(format_severity(severity), Time.now, progname, message)

      unless data.is_a?(Hash)
        data = {data: data}
      end

      @logger.post(@tag, data)
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