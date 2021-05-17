# frozen_string_literal: true

RSpec.describe TTY::Sparkline, "#render" do
  it "renders empty string with no data" do
    sparkline = TTY::Sparkline.new
    expect(sparkline.render).to eq("")
  end

  it "renders full bar for an array with a single positive number" do
    sparkline = TTY::Sparkline.new(data: [5])
    expect(sparkline.render).to eq("█")
  end

  it "renders full bar for an array with a single near zero number" do
    sparkline = TTY::Sparkline.new(data: [1e-10])
    expect(sparkline.render).to eq("█")
  end

  it "renders full bar for an array with a single negative number" do
    sparkline = TTY::Sparkline.new(data: [-5])
    expect(sparkline.render).to eq("█")
  end

  it "renders an array of zeros as smallest bars" do
    sparkline = TTY::Sparkline.new(data: [0, 0, 0])
    expect(sparkline.render).to eq("▁▁▁")
  end

  it "renders an array of identical numbers as full bars" do
    sparkline = TTY::Sparkline.new(data: [10, 10, 10])
    expect(sparkline.render).to eq("███")
  end

  it "renders an increasing range of integers matching all bars" do
    sparkline = TTY::Sparkline.new(data: (1..8))
    expect(sparkline.render).to eq("▁▂▃▄▅▆▇█")
  end

  it "renders a decreasing range of integers matching all bars" do
    sparkline = TTY::Sparkline.new(data: (1..8).to_a.reverse)
    expect(sparkline.render).to eq("█▇▆▅▄▃▂▁")
  end

  it "renders an increasing range of negative integers matching all bars" do
    sparkline = TTY::Sparkline.new(data: (-8..-1))
    expect(sparkline.render).to eq("▁▂▃▄▅▆▇█")
  end

  it "renders a decreasing range of negative integers matching all bars" do
    sparkline = TTY::Sparkline.new(data: (-8..-1).to_a.reverse)
    expect(sparkline.render).to eq("█▇▆▅▄▃▂▁")
  end

  it "renders an increasing range of integers exceeding available bars" do
    sparkline = TTY::Sparkline.new(data: (1..20))
    expect(sparkline.render).to eq("▁▁▁▂▂▂▃▃▃▄▄▅▅▅▆▆▆▇▇█")
  end

  it "renders a range of integers increasing by the same step amount" do
    sparkline = TTY::Sparkline.new(data: (10..45).step(5))
    expect(sparkline.render).to eq("▁▂▃▄▅▆▇█")
  end

  it "renders identical bars for number ranges differing only in scale" do
    sparkline = TTY::Sparkline.new(data: (10..45).step(5))
    sparkline2 = TTY::Sparkline.new(data: (100..450).step(50))
    expect(sparkline.render).to eq(sparkline2.render)
  end

  it "renders non-numeric values as empty spaces" do
    sparkline = TTY::Sparkline.new(data: [1, 2.4, "foo", 3.1, nil, 5.3, 6, "", 8])
    expect(sparkline.render).to eq("▁▂ ▃ ▅▆ █")
  end

  it "renders only numeric values" do
    sparkline = TTY::Sparkline.new(data: [1, 2.4, "foo", 3.1, nil, 5.3, 6, "", 8],
                                   non_numeric: :ignore)
    expect(sparkline.render).to eq("▁▂▃▅▆█")
  end

  it "renders non-numeric values as the smallest bar" do
    sparkline = TTY::Sparkline.new(data: [1, 2.4, "foo", 3.1, nil, 5.3, 6, "", 8],
                                   non_numeric: :minimum)
    expect(sparkline.render).to eq("▁▂▁▃▁▅▆▁█")
  end

  it "raises when non_numeric option has invalid value" do
    expect {
      TTY::Sparkline.new(non_numeric: :unknown)
    }.to raise_error(TTY::Sparkline::Error,
                     "unknown non_numeric value: :unknown")
  end

  it "renders negative numbers in proportion to the remaining" do
    sparkline = TTY::Sparkline.new(data: [-50, -100, 0, 100, 50, 0, -200, 10])
    expect(sparkline.render).to eq("▄▃▅█▆▅▁▅")
  end

  it "scales bars against a custom minimum value less than any value" do
    sparkline = TTY::Sparkline.new(data: (1..8), min: -5)
    expect(sparkline.render).to eq("▄▄▅▅▆▆▇█")
  end

  it "scales bars against a custom minimum value above the lowest value" do
    sparkline = TTY::Sparkline.new(data: (1..8), min: 5)
    expect(sparkline.render).to eq("▁▁▁▁▁▃▅█")
  end

  it "scales bars below minimum value as if they are minimum value" do
    sparkline = TTY::Sparkline.new(data: (1..8), min: 5)
    sparkline2 = TTY::Sparkline.new(data: [5, 5, 5, 5, 5, 6, 7, 8], min: 5)
    expect(sparkline.render).to eq(sparkline2.render)
  end

  it "scales bars against a custom maximum value above any value" do
    sparkline = TTY::Sparkline.new(data: (1..8), max: 20)
    expect(sparkline.render).to eq("▁▁▁▂▂▂▃▃")
  end

  it "scales bars against a custom maximum value lower than the maximum" do
    sparkline = TTY::Sparkline.new(data: (1..8), max: 5)
    expect(sparkline.render).to eq("▁▂▄▆████")
  end

  it "scales bars above maximum value as if they are maximum value" do
    sparkline = TTY::Sparkline.new(data: (1..8), max: 5)
    sparkline2 = TTY::Sparkline.new(data: [1, 2, 3, 4, 5, 5, 5, 5], max: 5)
    expect(sparkline.render).to eq(sparkline2.render)
  end

  it "scales bars against a custom minimum and maximum value" do
    sparkline = TTY::Sparkline.new(data: (1..8), min: 3, max: 6)
    expect(sparkline.render).to eq("▁▁▁▃▅███")
  end

  it "sets a custom minimum and maximum value when calling render" do
    sparkline = TTY::Sparkline.new(data: (1..8))
    expect(sparkline.render(min: 3, max: 6)).to eq("▁▁▁▃▅███")
  end

  it "sets a custom minimum and maximum value with attributes" do
    sparkline = TTY::Sparkline.new(data: (1..8))
    sparkline.min = 3
    sparkline.max = 6
    expect(sparkline.render).to eq("▁▁▁▃▅███")
  end

  it "renders full bars when maximum and minimum are the same" do
    sparkline = TTY::Sparkline.new(data: (1..8), min: 5, max: 5)
    expect(sparkline.render).to eq("████████")
  end

  it "raises when maximum value is lower than minimum during initialisation" do
    expect {
      TTY::Sparkline.new(min: 1, max: 0)
    }.to raise_error(TTY::Sparkline::Error,
                     "maximum value cannot be less than minimum")
  end

  it "raises when maximum value is lower than minimum when rendering" do
    sparkline = TTY::Sparkline.new(data: (1..8))
    expect {
      sparkline.render(min: 1, max: 0)
    }.to raise_error(TTY::Sparkline::Error,
                     "maximum value cannot be less than minimum")
  end

  it "renders an increasing range of integers with custom bars" do
    sparkline = TTY::Sparkline.new(data: (1..8), bars: %w[_ - = ^])
    expect(sparkline.render).to eq("___--==^")
  end

  it "appends numbers after initialisation" do
    sparkline = TTY::Sparkline.new
    sparkline.push(1).push(2).push(3, 4)
    expect(sparkline.size).to eq(4)
    expect(sparkline.render).to eq("▁▃▅█")

    sparkline.append(5).append(6)
    sparkline << 7 << 8
    expect(sparkline.size).to eq(8)
    expect(sparkline.render).to eq("▁▂▃▄▅▆▇█")
  end

  it "appends without overflowing maximum buffer size" do
    sparkline = TTY::Sparkline.new(buffer_size: 5, min: 0)
    sparkline.push(*(1..8).to_a)
    expect(sparkline.size).to eq(5)
    expect(sparkline.render).to eq("▄▅▆▇█")
  end

  it "renders up to the maximum width" do
    sparkline = TTY::Sparkline.new(data: (1..8), width: 4)
    expect(sparkline.render).to eq("▅▆▇█")
  end

  context "with block" do
    it "renders one row high chart yielding value, bar, column and row" do
      sparkline = TTY::Sparkline.new(data: (1..8))
      yielded = []

      rendered = sparkline.render do |val, bar, col, row|
        yielded << [val, bar, col, row]
        "#{bar}|"
      end

      expect(yielded).to eq([
        [1, "▁", 0, 0], [2, "▂", 1, 0], [3, "▃", 2, 0], [4, "▄", 3, 0],
        [5, "▅", 4, 0], [6, "▆", 5, 0], [7, "▇", 6, 0], [8, "█", 7, 0]
      ])

      expect(rendered).to eq("▁|▂|▃|▄|▅|▆|▇|█|")
    end

    it "renders 3 rows high chart yielding value, bar, column and row" do
      sparkline = TTY::Sparkline.new(data: (1..4), height: 3)
      yielded = []

      rendered = sparkline.render do |val, bar, col, row|
        yielded << [val, bar, col, row]
        "#{bar}|"
      end

      expect(yielded).to eq([
        [1, " ", 0, 0], [2, " ", 1, 0], [3, " ", 2, 0], [4, "▆", 3, 0],
        [1, " ", 0, 1], [2, " ", 1, 1], [3, "▇", 2, 1], [4, "█", 3, 1],
        [1, "▁", 0, 2], [2, "█", 1, 2], [3, "█", 2, 2], [4, "█", 3, 2]
      ])

      expect(rendered).to eq([
        " | | |▆|",
        " | |▇|█|",
        "▁|█|█|█|"
      ].join("\n"))
    end
  end

  context "with height" do
    it "renders chart with height set to 2 rows" do
      sparkline = TTY::Sparkline.new(data: (1..8), height: 2)
      expect(sparkline.render).to eq([
        "    ▁▃▅▇",
        "▁▃▅▇████"
      ].join("\n"))
    end

    it "renders chart with height set to 5 rows" do
      sparkline = TTY::Sparkline.new(data: (1..8), height: 5)
      expect(sparkline.render).to eq([
        "       ▄",
        "     ▂▇█",
        "    ▅███",
        "  ▃█████",
        "▁▆██████"
      ].join("\n"))
    end

    it "renders chart with height set to 3 rows and width set to 4 columns" do
      sparkline = TTY::Sparkline.new(data: (1..8), height: 3, width: 4)
      expect(sparkline.render).to eq([
        "  ▃▆",
        "▅███",
        "████"
      ].join("\n"))
    end
  end

  context "with position" do
    it "renders chart with the left position set to 5 columns" do
      sparkline = TTY::Sparkline.new(data: (1..8), left: 5)
      expect(sparkline.render).to eq("\e[5G▁▂▃▄▅▆▇█")
    end

    it "renders 3 rows high chart with the left position set to 5 columns" do
      sparkline = TTY::Sparkline.new(data: (1..8), left: 5, height: 3)
      expect(sparkline.render).to eq([
        "\e[5G      ▃▆",
        "\e[5G   ▂▅███",
        "\e[5G▁▄▇█████"
      ].join("\n"))
    end

    it "renders chart with top position set to 2 rows" do
      sparkline = TTY::Sparkline.new(data: (1..8), top: 2)
      expect(sparkline.render).to eq("\e[2d▁▂▃▄▅▆▇█")
    end

    it "renders 3 rows high chart with the top position set to 2 rows" do
      sparkline = TTY::Sparkline.new(data: (1..8), top: 2, height: 3)
      expect(sparkline.render).to eq([
        "\e[2d      ▃▆",
        "\e[3d   ▂▅███",
        "\e[4d▁▄▇█████"
      ].join("\n"))
    end

    it "renders chart with the top set to 2 rows and left to 5 columns" do
      sparkline = TTY::Sparkline.new(data: (1..8), top: 2, left: 5)
      expect(sparkline.render).to eq("\e[3;6H▁▂▃▄▅▆▇█")
    end

    it "renders 3 rows high chart with the top and left position" do
      sparkline = TTY::Sparkline.new(data: (1..8), top: 2, left: 5, height: 3)
      expect(sparkline.render).to eq([
        "\e[3;6H      ▃▆",
        "\e[4;6H   ▂▅███",
        "\e[5;6H▁▄▇█████"
      ].join("\n"))
    end

    it "renders 3 rows by 4 columns chart with the top and left position" do
      sparkline = TTY::Sparkline.new(data: (1..8), top: 2, left: 5,
                                     height: 3, width: 4)
      expect(sparkline.render).to eq([
        "\e[3;6H  ▃▆",
        "\e[4;6H▅███",
        "\e[5;6H████"
      ].join("\n"))
    end
  end
end
