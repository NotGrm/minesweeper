module Minesweeper
  class Command
    class Quit < Command
      def initialize(input)
        @input = input
        puts "quitted"
      end

      def execute(grid)
        grid.reveal_all_cells!
      end
    end
  end
end
