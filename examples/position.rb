# frozen_string_literal: true

require_relative  "../lib/tty-sparkline"

data = Array.new(100) { rand(100) }
sparkline = TTY::Sparkline.new(data: data, top: 10, left: 50, height: 5)
print sparkline.cursor.clear_screen
puts sparkline.render
