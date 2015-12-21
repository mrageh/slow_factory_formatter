require 'spec_helper'

RSpec.describe SlowFactoryFormatter do
  let(:output)          { double(:output).as_null_object }
  let(:notification)    { double(:notification).as_null_object }
  let(:factories_table) { double(:factories_table, add_factory: {}) }
  subject { described_class.new(output) }

  before do
    allow(subject).to receive(:factories_table).and_return(factories_table)
    allow(factories_table).to receive(:total_duration).and_return(1)
    allow(notification).to receive(:duration).and_return(2)
  end

  describe '#start' do
    let(:start)           { double(:start).as_null_object }
    let(:finish)          { double(:finish).as_null_object }
    let(:payload)         { double(:payload).as_null_object }

    it 'subscribes to factory_girl.run_factory event' do
      expect(ActiveSupport::Notifications).to receive(:subscribe).with("factory_girl.run_factory").
        and_yield(any_args, start, finish, any_args, payload)
      expect(factories_table).to receive(:add_factory).with(start: start, finish: finish, payload: payload)

      subject.start(notification)
    end

    it 'passes factory info to factories_table' do
      allow(ActiveSupport::Notifications).to receive(:subscribe).with("factory_girl.run_factory").
        and_yield(any_args, start, finish, any_args, payload)

      expect(factories_table).to receive(:add_factory).with(start: start, finish: finish, payload: payload)

      subject.start(notification)
    end
  end

  describe '#dump_summary' do
    it 'displays table of slow factories' do
      expect(factories_table).to receive(:display_slow_factories)

      subject.dump_summary(notification)
    end

    it 'calculates and appends the percentage of time factories were setup' do
      expected_message = "Tests took 2.0s to run, factories took 1.0s to setup. So 50.0% of total test time was spent setting up factories"

      allow(factories_table).to receive(:display_slow_factories)

      expect($stdout).to receive(:puts).with(expected_message)

      subject.dump_summary(notification)
    end
  end
end
