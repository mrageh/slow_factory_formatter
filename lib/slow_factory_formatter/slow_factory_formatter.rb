require "terminal-table"
require 'active_support'
require "rspec/core"
require "rspec/core/formatters/documentation_formatter"
require_relative "factories_table"

class SlowFactoryFormatter < RSpec::Core::Formatters::DocumentationFormatter
  RSpec::Core::Formatters.register self, :start, :dump_summary

  def initialize(output)
    @factories_table ||= FactoriesTable.new
    super
  end

  def start(notification)
    ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |_, start, finish, id, payload|
      factories_table.add_factory(start: start, finish: finish, payload: payload)
    end

    super
  end

  def dump_summary(notification)
    factories_table.display_slow_factories
    display_factory_duration(notification)

    super
  end

  private

  attr_reader :factories_table

  def display_factory_duration(notification)
    spec_time = notification.duration.to_f.round(2)
    factory_time = factories_table.total_duration.to_f.round(2)
    percentage = (factory_time / spec_time) * 100

    puts "Tests took #{spec_time}s to run, factories took #{factory_time}s to setup. So #{percentage.round(1)}% of total test time was spent setting up factories"
  end
end
