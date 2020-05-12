
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mumukit/flow/version"

Gem::Specification.new do |spec|
  spec.name          = "mumukit-flow"
  spec.version       = Mumukit::Flow::VERSION
  spec.authors       = ["Franco Bulgarelli"]
  spec.email         = ["franco@mumuki.org"]

  spec.summary       = %q{Adaptive flow implementation for the mumukit-platform}
  spec.homepage      = "https://mumuki.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mumukit-core", "~> 1.17"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
