require 'spec_helper'

RSpec.describe FactoriesTable do
  subject { described_class.new }
  let(:payload)     { { name: :user, strategy: :create } }

  describe '#add_factory' do
    let(:new_payload) { { name: :manager, strategy: :build } }
    let(:start)       { 1 }
    let(:finish)      { 6 }

    it 'does not overwrite a factory with a different name' do
      subject.add_factory(start: start, finish: finish, payload: payload)
      subject.add_factory(start: start, finish: finish, payload: new_payload)

      expect(subject.factories).to eq({
        payload[:name]     => { payload[:strategy] => { time_in_seconds: finish - start, occurences: 1, }},
        new_payload[:name] => { new_payload[:strategy] => { time_in_seconds: finish - start, occurences: 1, }}
      })
    end

    context 'when its a new factory name' do
      it 'stores the factory and its data' do
        subject.add_factory(start: start, finish: finish, payload: payload)

        expect(subject.factories).to eq({
          payload[:name] => { payload[:strategy] => { time_in_seconds: finish - start, occurences: 1, }}
        })
      end
    end

    context 'when its an exisisting factory name' do
      it 'modifies the data of the factory with the same name' do
        subject.add_factory(start: start, finish: finish, payload: payload)
        subject.add_factory(start: start, finish: finish, payload: payload)

        expect(subject.factories).to eq({
          payload[:name] => { payload[:strategy] => { time_in_seconds: (finish - start) * 2, occurences: 2, }}
        })
      end
    end
  end

  describe '#display_slow_factories' do
    context 'when there are slow factories' do
      it 'displays a table containing the data of the slow factories' do
        start  = 2
        finish = 9
        table_headings = ['Factory Name', 'Create', 'Build', 'Build Stubbed', 'Total Time (in secs)']

        table = Terminal::Table.new(
          title: "Slow Factories",
          headings: table_headings
        )
        row = [:user, 1, 0, 0, finish - start]
        table << row

        subject.add_factory(start: start, finish: finish, payload: payload)

        expect { subject.display_slow_factories }.to output.to_stdout
      end
    end

    context 'when there are no slow factories' do
      it 'does not display anything' do
        expect { subject.display_slow_factories }.not_to output.to_stdout
      end
    end
  end

  describe '#total_duration' do
    it 'tracks total duration of time spent setting up factories' do
      start  = 1
      finish = 3

      subject.add_factory(start: start, finish: finish, payload: payload)
      subject.add_factory(start: start, finish: finish, payload: payload)

      expected = (finish - start) * 2

      expect(subject.total_duration).to eq(expected)
    end
  end
end
