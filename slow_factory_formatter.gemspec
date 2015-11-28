# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "slow_factory_formatter"
  spec.version       = "0.1.0"
  spec.authors       = ["mrageh"]
  spec.email         = ["adam@mrageh.com"]

  spec.summary       = %q{Generate a table that contains the slowest factories}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/mrageh/slow_factory_formatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec-core", "~> 3.4"
  spec.add_runtime_dependency "terminal-table", "~> 1.5"
  spec.add_runtime_dependency "activesupport", "~> 4"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end
