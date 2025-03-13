module Minesweeper
  class Command
    class Flag < Command
      attr_reader :coords
      
      def initialize(input)
        @input = input

        @coords = input.scan(/\d+/).map(&:to_i)
      end

      def execute(grid)
        coords => col, row
        grid.find(col - 1, row -1) => cell

        grid.flag_cell(cell)
      end
    end
  end
end
