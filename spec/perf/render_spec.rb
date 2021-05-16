# frozen_string_literal: true

require "erb"
require "rspec-benchmark"

RSpec.describe TTY::Sparkline, "#render" do
  include RSpec::Benchmark::Matchers

  it "renders data at most 3x slower than ERB template" do
    data = (1..100)
    template = ERB.new "Sparkline for <%= data %>"
    sparkline = TTY::Sparkline.new(data: data)

    expect {
      sparkline.render
    }.to perform_slower_than {
      template.result(binding)
    }.at_most(3).times
  end

  it "renders a single row chart allocating no more than 12 objects" do
    data = (1..100)
    expect {
      sparkline = TTY::Sparkline.new(data: data)
      sparkline.render
    }.to perform_allocation(12).objects
  end

  it "renders 5 rows high chart allocating no more than 24 objects" do
    data = (1..100)
    expect {
      sparkline = TTY::Sparkline.new(data: data, height: 5)
      sparkline.render
    }.to perform_allocation(24).objects
  end
end
