# frozen_string_literal: true

require_relative  "../lib/tty-sparkline"

data = Array.new(100) { rand(100) }
sparkline = TTY::Sparkline.new(data, top: 0, left: 0, height: 5)
print sparkline.cursor.clear_screen
puts sparkline.render
