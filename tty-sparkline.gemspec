# frozen_string_literal: true

require_relative "lib/tty/sparkline/version"

Gem::Specification.new do |spec|
  spec.name          = "tty-sparkline"
  spec.version       = TTY::Sparkline::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["piotr@piotrmurach.com"]
  spec.summary       = "Sparkline charts for terminal applications."
  spec.description   = "Sparkline charts for terminal applications."
  spec.homepage      = "https://ttytoolkit.org"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["bug_tracker_uri"] = "https://github.com/piotrmurach/tty-sparkline/issues"
  spec.metadata["changelog_uri"] = "https://github.com/piotrmurach/tty-sparkline/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/tty-sparkline"
  spec.metadata["funding_uri"] = "https://github.com/sponsors/piotrmurach"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/piotrmurach/tty-sparkline"

  spec.files         = Dir["lib/**/*"]
  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.0.0")

  spec.add_dependency "tty-cursor", "~> 0.7"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0"
end
