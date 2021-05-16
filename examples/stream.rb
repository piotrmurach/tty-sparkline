# frozen_string_literal: true

require_relative "../lib/tty-sparkline"

sparkline = TTY::Sparkline.new(left: 10, top: 10, height: 3, width: 40)

print sparkline.cursor.clear_screen
loop do
  sparkline << rand(50)
  print sparkline.render
  sleep(0.05)
end
