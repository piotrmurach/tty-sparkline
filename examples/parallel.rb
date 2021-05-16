# frozen_string_literal: true

require_relative "../lib/tty-sparkline"

sparkline = TTY::Sparkline.new(left: 10, top: 10, height: 2, width: 40)
sparkline2 = TTY::Sparkline.new(left: 10, top: 14, height: 10, width: 40)

print sparkline.cursor.clear_screen
sparkline.cursor.invisible do
  loop do
    sparkline << rand(50)
    sparkline2 << rand(50)
    print sparkline.render
    print sparkline2.render
    sleep(0.05)
  end
end
