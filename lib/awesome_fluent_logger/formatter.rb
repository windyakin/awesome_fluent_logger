# frozen_string_literal: true

require 'logger'

module AwesomeFluentLogger
  class Formatter < ::Logger::Formatter
    def call(severity, time, progname, data)
      {
        severity: severity,
        time: format_datetime(time),
        progname: progname,
        message: data
      }
    end

    def datetime_format=(format)
      @datetime_format = format == '%iso8601' ? '%Y-%m-%dT%H:%M:%S%:z' : format
    end

    protected

    def format_datetime(time)
      time.strftime(@datetime_format || '%Y-%m-%d %H:%M:%S.%6N %z')
    end
  end
end
