# frozen_string_literal: true

require_relative "../lib/tty-sparkline"

data = Array.new(100) { rand(100) }
sparkline = TTY::Sparkline.new(data, height: 5)
puts sparkline.render
