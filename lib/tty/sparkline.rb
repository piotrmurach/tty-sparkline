# frozen_string_literal: true

require_relative "sparkline/version"

module TTY
  # Responsible for drawing sparkline in a terminal
  #
  # @api public
  class Sparkline
    class Error < StandardError; end
  end # Sparkline
end # TTY
