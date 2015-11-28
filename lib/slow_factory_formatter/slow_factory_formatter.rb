require "terminal-table"
require "active_support"
require "rspec/core"
require "rspec/core/formatters/documentation_formatter"

class SlowFactoryFormatter < RSpec::Core::Formatters::DocumentationFormatter
  RSpec::Core::Formatters.register self, :start, :dump_summary

  def initialize(output)
    @factory_girl_results = {}
    super
  end

  def start(notification)
    ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
      execution_time_in_seconds = finish - start
      factory_name = payload[:name].to_s
      strategy_name = payload[:strategy]
      factory_girl_results[factory_name] ||= Hash.new { |factory, strategy| factory[strategy] = Hash.new(0) }
      factory_girl_results[factory_name][strategy_name][:occurences] += 1
      factory_girl_results[factory_name][strategy_name][:time_in_seconds] += execution_time_in_seconds
    end

    super
  end

  def dump_summary(notification)
    remove_fast_factories(factory_girl_results)

    if factory_girl_results.any?
      puts create_table(factory_girl_results)
    end

    super
  end

  private

  attr_reader :factory_girl_results

  def create_table(factory_girl_results)
    table_headings = ['Factory Name', 'Create', 'Build', 'Build Stubbed', 'Total Time (in secs)']

    table = Terminal::Table.new(
      title: "Slow Factories",
      headings: table_headings
    )

    factory_girl_results.each do |factory_name, data|
      populate_table(table, factory_name, data)
    end

    table
  end

  def populate_table(table, factory_name, data)
    row = []
    row << factory_name

    [:create, :build, :build_stubbed].map do |strategy|
      row << data[strategy][:occurences]
    end

    time_in_seconds = data.inject(0) { |acc, (_, prop)| acc += prop[:time_in_seconds] }

    row << time_in_seconds.round(2)
    table << row
  end

  def remove_fast_factories(factory_girl_results)
    factory_girl_results.select! do |factory_name, data|
      data.any? { |strategy_name, prop| prop[:occurences] > 5 || prop[:time_in_seconds] > 0.5 }
    end
  end
end
