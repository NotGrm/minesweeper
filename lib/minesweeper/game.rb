require_relative "grid"
require_relative "cell"

require_relative "action/defuse"
require_relative "action/quit"
require_relative "action/unsupported"

module Minesweeper
  class Game
    attr_reader :grid, :mines_count
    
    def initialize
      @mines_count = 1 #4
      @row_count = 4
      @col_count = 3

      @grid = Grid.build(@row_count, @col_count) do |row, col|
        Cell.new(col, row)
      end
    end

    def start
      drop_mines

      loop do
        quit = false

        display_grid
        
        input = wait_user_input
        action = parse_input(input)

        case action
        when Action::Defuse
          handle_defuse(action)
        when Action::Quit
          handle_quit(action)
          break
        else
          puts "Action unknown, try new one!"
        end
      end
    end

    private

      def drop_mines
        # grid.sample(mines_count).each do |cell|
        grid.find(0,0).then do |cell|
          puts cell.inspect
          cell.put_mine

          grid.get_neighbours(cell)
              .each(&:warn!)
        end
      end

      def wait_user_input
        puts "Which case would you like to reveal?"
        gets.chomp
      end

      def parse_input(input)
        case input
        when /\A\d+,\d+\z/
          Action::Defuse.new(input)
        when "quit"
          Action::Quit.new
        else
          Action::Unsupported(input)
        end      
      end

      def handle_defuse(action)
        x, y = action.coords
        cell = grid.find(x -1, y - 1)

        unless cell
          puts "Cell unknown, please try new coordinates"
          return
        end

        grid.reveal_cell_and_neighbours(cell)
      end

      def handle_quit(action)
        grid.reveal_all_cells!
        display_grid
      end

      def display_grid
        puts grid.draw
      end

      def reveal_cells
        grid.each(&:reveal!)
      end
  end
end
