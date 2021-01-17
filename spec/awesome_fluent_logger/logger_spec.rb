# frozen_string_literal: true
 
require 'spec_helper'
require 'logger'

RSpec.describe AwesomeFluentLogger::Logger do
  let(:time) { '2020-02-10 12:34:56.123456 +0000' }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  class MockFluentLogger
    attr_accessor :logs

    def initialize
      @logs = []
    end

    def post(tag, msg)
      logs << [tag, msg.dup]
    end

    def clear
      logs.clear
    end

    def close; end

    def connect?
      true
    end
  end

  let(:logger) { AwesomeFluentLogger.new(fluent_logger, progname: progname, level: level, tag: tag) }
  let(:fluent_logger) { MockFluentLogger.new }
  let(:progname) { 'progname' }
  let(:tag) { 'rspec' }
  let(:level) { Logger::INFO }

  describe 'the log level' do
    context 'is higher than the configured level' do
      it 'with :unknown' do
        logger.unknown 'hello world'
        expect(fluent_logger.logs).to match([["rspec", {progname: progname, severity: 'ANY', message: 'hello world', time: time}]])
      end

      it 'with :fatal' do
        logger.fatal 'hello world'
        expect(fluent_logger.logs).to match([["rspec", {progname: progname, severity: 'FATAL', message: 'hello world', time: time}]])
      end

      it 'with :warn' do
        logger.warn 'hello world'
        expect(fluent_logger.logs).to match([["rspec", {progname: progname, severity: 'WARN', message: 'hello world', time: time}]])
      end

      it 'with :info' do
        logger.info 'hello world'
        expect(fluent_logger.logs).to match([["rspec", {progname: progname, severity: 'INFO', message: 'hello world', time: time}]])
      end
    end

    context 'when the log level is too low then silent' do
      it 'with :debug' do
        logger.debug 'hello world'
        expect(fluent_logger.logs).to be_empty
      end
    end
  end

  describe 'the message' do
    it 'given block' do
      logger.info { "message in block" }
      expect(fluent_logger.logs).to match([["rspec", {progname: progname, severity: 'INFO', message: 'message in block', time: time}]])
    end
  end
end
