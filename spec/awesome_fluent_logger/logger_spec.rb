# frozen_string_literal: true
 
require 'spec_helper'
require 'logger'

RSpec.describe AwesomeFluentLogger::Logger do
  let(:time) { '2020-02-10 12:34:56.123456 +0000' }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  class MockFluentLogger
    attr_accessor :logs

    def initialize(tag_prefix = nil, **_kvargs)
      @tag_prefix = tag_prefix
      @logs = []
    end

    def post(tag, msg)
      logs << [[@tag_prefix, tag].join('.'), msg.dup]
    end

    def clear
      logs.clear
    end

    def close; end

    def connect?
      true
    end
  end

  let(:logger) { AwesomeFluentLogger.new(fluent: fluent_logger, level: level) }
  let(:fluent_logger) { MockFluentLogger.new(tag) }
  let(:level) { Logger::INFO }
  let(:tag) { 'rspec' }

  describe 'initialize argument :fluent' do
    context 'is a Hash paramater' do
      subject { AwesomeFluentLogger.new(fluent: { host: 'fluentd', port: 24224 }) }
      it 'then call fluent-logger initialize' do
        expect(Fluent::Logger::FluentLogger).to receive(:new).with(nil, { host: 'fluentd', port: 24224 })
        subject
      end
    end
  end

  describe 'the log level' do
    context 'is higher than the configured level' do
      it 'with :unknown' do
        logger.unknown 'hello world'
        expect(fluent_logger.logs).to match([["rspec.any", { progname: nil, severity: 'ANY', message: 'hello world', time: time }]])
      end

      it 'with :fatal' do
        logger.fatal 'hello world'
        expect(fluent_logger.logs).to match([["rspec.fatal", { progname: nil, severity: 'FATAL', message: 'hello world', time: time }]])
      end

      it 'with :warn' do
        logger.warn 'hello world'
        expect(fluent_logger.logs).to match([["rspec.warn", { progname: nil, severity: 'WARN', message: 'hello world', time: time }]])
      end

      it 'with :info' do
        logger.info 'hello world'
        expect(fluent_logger.logs).to match([["rspec.info", { progname: nil, severity: 'INFO', message: 'hello world', time: time }]])
      end
    end

    context 'when the log level is too low then silent' do
      it 'with :debug' do
        logger.debug 'hello world'
        expect(fluent_logger.logs).to be_empty
      end
    end
  end

  describe 'the tag' do
    context 'given tag_prefix parasms' do
      subject(:logger) { AwesomeFluentLogger.new(fluent: { tag_prefix: tag }) }
      let(:tag) { 'tagging' }

      specify 'includes fluent-logger initialize args' do
        expect(Fluent::Logger::FluentLogger).to receive(:new).with(tag, { tag_prefix: tag }).and_return(fluent_logger)
        subject
      end

      it 'then add tag to prefix' do
        allow(Fluent::Logger::FluentLogger).to receive(:new).and_return(fluent_logger)
        subject
        logger.info 'message'
        expect(fluent_logger.logs).to match([["#{tag}.info", { progname: nil, severity: 'INFO', message: 'message', time: time }]])
      end

      context 'add progname' do
        subject(:logger) { AwesomeFluentLogger.new(fluent: { tag_prefix: tag }, progname: progname) }
        let(:progname) { 'rspec' }

        specify 'then add tags to prefix' do
          allow(Fluent::Logger::FluentLogger).to receive(:new).and_return(fluent_logger)
          subject
          logger.info 'message'
          expect(fluent_logger.logs).to match([["#{tag}.#{progname}.info", { progname: progname, severity: 'INFO', message: 'message', time: time }]])
        end
      end
    end
  end

  describe 'the message' do
    it 'given block' do
      logger.info { "message in block" }
      expect(fluent_logger.logs).to match([["rspec.info", { progname: nil, severity: 'INFO', message: 'message in block', time: time }]])
    end
  end

  describe 'formatter' do
    context 'not specific datetime_format' do
      let(:logger) { AwesomeFluentLogger.new(fluent: fluent_logger) }
      it 'then timestamp format is original format' do
        logger.info 'hello world'
        expect(fluent_logger.logs).to match([["rspec.info", {progname: nil, severity: 'INFO', message: 'hello world', time: time}]])
      end
    end

    context 'set datetime_format %iso8601' do
      let(:logger) { AwesomeFluentLogger.new(fluent: fluent_logger, datetime_format: '%iso8601') }

      it 'then timestamp format is ISO8601' do
        logger.info 'hello world'
        expect(fluent_logger.logs).to match([["rspec.info", {progname: nil, severity: 'INFO', message: 'hello world', time: '2020-02-10T12:34:56+00:00'}]])
      end
    end
  end
end
