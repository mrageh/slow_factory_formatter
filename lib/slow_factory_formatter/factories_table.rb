class FactoriesTable
  attr_reader :factories, :total_duration

  def initialize
    @factories = {}
    @total_duration = 0
  end

  def add_factory(start:, finish:, payload:)
    execution_time_in_seconds = finish - start
    @total_duration += execution_time_in_seconds

    factory_name = payload[:name]
    strategy_name = payload[:strategy]

    factories[factory_name] ||= Hash.new { |factory, strategy| factory[strategy] = Hash.new(0) }
    factories[factory_name][strategy_name][:occurences] += 1
    factories[factory_name][strategy_name][:time_in_seconds] += execution_time_in_seconds
  end

  def display_slow_factories
    remove_fast_factories

    if factories.any?
      populate_table
      puts table
    end
  end

  private

  attr_reader :table

  def remove_fast_factories
    factories.select! do |factory_name, data|
      data.any? { |strategy_name, prop| prop[:occurences] > 5 || prop[:time_in_seconds] > 0.5 }
    end
  end

  def populate_table
    table_headings = ['Factory Name', 'Create', 'Build', 'Build Stubbed', 'Total Time']
    @table = Terminal::Table.new(
      title: "Slow Factories",
      headings: table_headings
    )

    factories.each do |factory_name, data|
      populate_row(factory_name, data)
    end
  end

  def populate_row(factory_name, data)
    row = []
    row << factory_name

    [:create, :build, :build_stubbed].map do |strategy|
      row << data[strategy][:occurences]
    end

    time_in_seconds = data.inject(0) { |acc, (_, prop)| acc += prop[:time_in_seconds] }
    time_in_seconds = '%.2f' % time_in_seconds
    time_in_seconds = "#{time_in_seconds} seconds"

    row << time_in_seconds
    table << row
  end
end
