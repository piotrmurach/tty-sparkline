# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "json", "2.4.1" if RUBY_VERSION == "2.0.0"
gem "pastel", "~> 0.8.0"

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.1.0")
  gem "rspec-benchmark", "~> 0.6.0"
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.7.0")
  gem "coveralls_reborn", "~> 0.29.0"
  gem "rubocop-performance", "~> 1.25"
  gem "rubocop-rake", "~> 0.7.1"
  gem "rubocop-rspec", "~> 3.6"
  gem "simplecov", "~> 0.22.0"
end
