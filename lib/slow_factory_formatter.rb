module RSpec
  lib = File.expand_path(File.dirname(File.dirname(__FILE__)))
  $LOAD_PATH << lib unless $LOAD_PATH.include?(lib)

  if defined?(::RSpec::Core) && ::RSpec::Core::Version::STRING >= '3.0.0'
    require "slow_factory_formatter/slow_factory_formatter"
  end
end
