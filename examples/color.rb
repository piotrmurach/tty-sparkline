# frozen_string_literal: true

require "pastel"

require_relative  "../lib/tty-sparkline"

pastel = Pastel.new
data = Array.new(120) { rand(100) }
min, max = data.minmax
avg = data.sum.fdiv(data.size)

sparkline = TTY::Sparkline.new(data: data, height: 6)

chart = sparkline.render do |val, bar, col, row|
  if val == max
    pastel.cyan(bar)
  elsif val == min
    pastel.magenta(bar)
  elsif val < avg
    pastel.red(bar)
  else
    pastel.green(bar)
  end
end

puts "#{pastel.green("■")} above avg #{pastel.red("■")} below avg " \
     "#{pastel.cyan("■")} max #{pastel.magenta("■")} min"
puts chart
