# frozen_string_literal: true

require_relative "../lib/tty-sparkline"

sparkline = TTY::Sparkline.new(1..8)
puts sparkline.render
