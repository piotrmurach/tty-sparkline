# frozen_string_literal: true

require "tty-cursor"

require_relative "sparkline/version"

module TTY
  # Responsible for drawing sparkline in a terminal
  #
  # @api public
  class Sparkline
    class Error < StandardError; end

    BARS = %w[▁ ▂ ▃ ▄ ▅ ▆ ▇ █].freeze

    EMPTY = ""

    MAX_BUFFER_SIZE = 2**14

    NEWLINE = "\n"

    NON_NUMERIC_CONVERSIONS = %i[empty ignore minimum].freeze

    SPACE = " "

    # The top position
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :top

    # The left position
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :left

    # The chart maximum width in terminal columns
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :width

    # The chart height in terminal lines
    #
    # @return [Integer]
    #
    # @api public
    attr_reader :height

    # The drawing cursor
    #
    # @return [TTY::Cursor]
    #
    # @api public
    attr_reader :cursor

    # The custom minimum value used for scaling bars
    #
    # @return [Numeric]
    #
    # @api public
    attr_accessor :min

    # The custom maximum value used for scaling bars
    #
    # @return [Numeric]
    #
    # @api public
    attr_accessor :max

    # Create a Sparkline instance
    #
    # @param [Array<Numeric>] data
    #   the data to chart
    # @param [Integer] top
    #   the top position
    # @param [Integer] left
    #   the left position
    # @param [Integer] height
    #   the height in terminal lines
    # @param [Integer] width
    #   the maximum width in terminal columns
    # @param [Numeric] min
    #   the custom minimum value
    # @param [Numeric] max
    #   the custom maximum value
    # @param [Array<String>] bars
    #   the bars used for display
    # @param [Integer] buffer_size
    #   the maximum buffer size
    # @param [Symbol] non_numeric
    #   the replacement for a non-numeric value
    #
    # @api public
    def initialize(data = [], top: nil, left: nil, height: 1, width: nil,
                   min: nil, max: nil, bars: BARS, buffer_size: MAX_BUFFER_SIZE,
                   non_numeric: :empty)
      check_minmax(min, max) if min && max
      check_non_numeric(non_numeric)

      @data = Array(data).dup
      @cached_data_size = @data.size
      @top = top
      @left = left
      @height = height
      @width = width
      @min = min
      @max = max
      @bars = bars
      @num_of_bars = bars.size
      @buffer_size = buffer_size
      @non_numeric = non_numeric
      @filter = ->(value) { value.is_a?(::Numeric) }
      @cursor = TTY::Cursor
    end

    # Append value(s)
    #
    # @example
    #   sparkline.push(1, 2, 3, 4)
    #
    # @example
    #   sparkline << 1 << 2 << 3 << 4
    #
    # @param [Array<Numeric>] nums
    #
    # @return [self]
    #
    # @api public
    def push(*nums)
      @data.push(*nums)
      @cached_data_size += nums.size

      if (overflow = @cached_data_size - @buffer_size) > 0
        @data.shift(overflow)
        @cached_data_size -= overflow
      end

      self
    end
    alias append push
    alias << push

    # The number of values
    #
    # @return [Integer]
    #
    # @api public
    def size
      @cached_data_size
    end

    # Render data as a sparkline chart
    #
    # @example
    #   sparkline.render
    #
    # @param [Integer] min
    #   the minimum value to display
    # @param [Integer] max
    #   the maximum value to display
    #
    # @return [String]
    #   the rendered sparkline chart
    #
    # @api public
    def render(min: nil, max: nil)
      return EMPTY if @data.empty?

      buffer = []
      calc_min, calc_max = data_minmax(min, max)
      check_minmax(calc_min, calc_max)

      height.times do |y|
        buffer << position(y) if position?
        @data[data_range].each.with_index do |value, x|
          bar_index = clamp_and_scale(value, calc_min, calc_max)
          bar = convert_to_bar(bar_index, height - 1 - y)
          bar = yield(value, bar, x, y) if block_given?
          buffer << bar
        end
        buffer << NEWLINE unless y == height - 1
      end

      buffer.join
    end

    private

    # Find the minimum and maximum value in the data
    #
    # @param [Integer] min
    #   the custom minimum value
    # @param [Integer] max
    #   the custom maximum value
    #
    # @return [Array<Numeric, Numeric>]
    #
    # @api private
    def data_minmax(min, max)
      calc_min, calc_max = @data.select(&@filter).minmax
      [min || @min || calc_min, max || @max || calc_max]
    end

    # Check maximum isn't less than minimum
    #
    # @raise [Error]
    #
    # @api private
    def check_minmax(min, max)
      return if min <= max

      raise Error, "maximum value cannot be less than minimum"
    end

    # Check whether non_numeric has a valid conversion type
    #
    # @param [Symbol] type
    #   the type of conversion
    #
    # @raise [Error]
    #
    # @api private
    def check_non_numeric(type)
      return if NON_NUMERIC_CONVERSIONS.include?(type)

      raise Error, "unknown non_numeric value: #{type.inspect}"
    end

    # Check whether or not to position this chart
    #
    # @return [Boolean]
    #
    # @api private
    def position?
      top || left
    end

    # Find a position at which to display this chart
    #
    # @return [String]
    #
    # @api private
    def position(offset = 0)
      if left && top
        cursor.move_to(left, top + offset)
      elsif left
        cursor.column(left)
      elsif top
        cursor.row(top + offset)
      end
    end

    # Find a range of data values matching width
    #
    # @return [Range]
    #
    # @api private
    def data_range
      start_index = 0
      if width && width < @cached_data_size
        start_index = @cached_data_size - width
      end
      start_index..-1
    end

    # Clamp value and scale it against height and number of bars
    #
    # @param [Object] value
    #   the value to clamp and scale
    # @param [Integer] min
    #   the minimum value
    # @param [Integer] max
    #   the maximum value
    #
    # @return [Integer]
    #
    # @api private
    def clamp_and_scale(value, min, max)
      return value unless value.is_a?(Numeric)

      clamped_value = value > max ? max : (value < min ? min : value)
      reduced_value = max == min ? clamped_value : clamped_value - min
      reduced_max = max == min ? (max.zero? ? 1 : max) : max - min
      reduced_value * height * (@num_of_bars - 1) / reduced_max
    end

    # Convert an index to a bar representation
    #
    # @param [Integer] bar_index
    #   the bar index within bars
    # @param [Integer] offset
    #   the offset from the bottom
    #
    # @return [String]
    #   the rendered bar
    #
    # @api private
    def convert_to_bar(bar_index, offset)
      return convert_non_numeric unless bar_index.is_a?(Numeric)

      if bar_index >= offset * @num_of_bars
        bar_index -= offset * @num_of_bars
        @bars[bar_index >= @num_of_bars ? -1 : bar_index]
      else
        SPACE
      end
    end

    # Convert non-numeric value into display string
    #
    # @return [String]
    #
    # @api private
    def convert_non_numeric
      case @non_numeric
      when :empty
        SPACE
      when :ignore
        EMPTY
      when :minimum
        @bars[0]
      end
    end
  end # Sparkline
end # TTY
