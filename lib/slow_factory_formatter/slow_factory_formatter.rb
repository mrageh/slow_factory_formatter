require "terminal-table"
require "active_support"
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
    super
  end

  private

  attr_reader :factories_table
end
