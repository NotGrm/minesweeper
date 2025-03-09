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
        x, y = coords
        cell = grid.find(x - 1, y - 1)

        raise CellNotGround if cell.nil?

        grid.reveal_cell(cell)
      end
    end
  end
end
