# frozen_string_literal: true

desc "Load gem inside irb console"
task :console do
  require "irb"
  require "irb/completion"
  require_relative "../lib/tty-sparkline"
  ARGV.clear
  IRB.start
end
task c: %w[console]
