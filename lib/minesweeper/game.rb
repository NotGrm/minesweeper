require_relative "grid"
require_relative "cell"
require_relative "player"

require_relative "action/defuse"
require_relative "action/quit"
require_relative "action/unsupported"

require "debug"

module Minesweeper
  class Game
    attr_reader :grid, :mines_count, :player

    attr_reader :graphics

    def initialize(graphics = CLI::Graphics.new)
      @graphics = graphics
      
      @mines_count = 1 #4
      @row_count = 4
      @col_count = 3

      @player = Player.new(lives: 1)
      @grid = Grid.build(@row_count, @col_count) do |row, col|
        Cell.new(col, row)
      end
    end

    def start
      drop_mines

      loop do
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
          message = "Action unknown, try new one!"
          graphics.display_error(message)
        end

        if game_over?
          display_lost_message
          break
        end
        
        if game_won?
          display_win_message
          break
        end
      end
    end

    private
      def game_won?
        grid.cells.none? { it.safe? && it.hidden? }
      end
    
      def game_over?
         player.dead?
      end
    
      def drop_mines
        grid.sample(mines_count).each do |cell|
          cell.put_mine

          grid.get_neighbours(cell)
              .each(&:warn!)
        end
      end

      def wait_user_input
        message = "Which case would you like to reveal?"
        graphics.display_message(message)
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
          message = "Cell unknown, please try new coordinates"
          graphics.display_message(message)
          return
        end

        player.boom! if cell.mined?
        grid.reveal_cell_and_neighbours(cell)
      end

      def handle_quit(action)
        grid.reveal_all_cells!
        display_grid
      end

      def display_grid
        graphics.display_grid(grid)
      end

      def display_lost_message
        message = "You revealed a mine, game is lost…"
        graphics.display_error(message)
      end

      def display_win_message
        message = "You avoided all the mines! Congrats!"
        graphics.display_success(message)
      end

      def reveal_cells
        grid.each(&:reveal!)
      end
  end
end
