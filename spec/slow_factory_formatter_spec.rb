require 'spec_helper'
require 'open3'

RSpec.describe "When running Slow Factory Formatter" do
  it 'a table of slow factories are generated' do
    stdout_str, _, status = run_example_test

    table_headings = ['Factory Name', 'Create', 'Build', 'Build Stubbed', 'Total Time']

    expected_table = Terminal::Table.new(
      title: "Slow Factories",
      headings: table_headings
    )

    row_one = [:seller, 100, 20, 10, "2.01 seconds"]
    row_two = [:product, 100, 20, 10, "4.34 seconds"]

    expected_table << row_one
    expected_table << row_two
    expected_table  = expected_table.to_s

    normalize_durations(stdout_str)
    normalize_durations(expected_table)

    expect(status.to_i).to eq(0)
    expect(stdout_str).to include(expected_table)
  end
  def run_example_test
    command = <<-EXECUTE
      bundle install
      gem list
      bundle exec rake db:migrate RAILS_ENV=test
      bundle exec rspec
    EXECUTE


    Bundler.with_clean_env do
      Open3.capture3(command, chdir: 'example')
    end
  end

  def normalize_durations(output)
    output.gsub!(/(?:\d+\.\d+ seconds)/) do |_|
      "n.nn seconds"
    end
  end
end
