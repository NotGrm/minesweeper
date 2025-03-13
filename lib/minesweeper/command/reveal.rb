require_relative '../command'
require_relative '../exceptions'

module Minesweeper
  class Command
    class Reveal < Command
      attr_reader :coords
      
      def initialize(input)
        @input = input

        @coords = input.scan(/\d+/).map(&:to_i)
      end

      def execute(grid)
        coords => col, row
        grid.find(col -1, row -1) => cell

        grid.reveal_cell(cell)
      end
    end
  end
end
