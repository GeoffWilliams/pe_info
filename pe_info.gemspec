# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pe_info/version'

Gem::Specification.new do |spec|
  spec.name          = "pe_info"
  spec.version       = PeInfo::VERSION
  spec.authors       = ["Declarative Systems"]
  spec.email         = ["sales@declarativesystems.com"]

  spec.summary       = %q{Get info about a PE installation tarball}
  spec.description   = %q{Peek inside a Puppet Enterprise tarball to lookup versions and capabilities}
  spec.homepage      = "https://github.com/declarativesystems/pe_info"
  spec.license       = "Apache-2.0"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
