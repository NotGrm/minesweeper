require_relative "grid"
require_relative "cell"
require_relative "player"

require "debug"

module Minesweeper
  class Game
    attr_reader :grid, :mines_count, :player

    attr_reader :graphics, :controller

    def initialize(graphics = CLI::Graphics.new, controller = CLI::Controller)
      @graphics = graphics
      @controller = controller
      
      @mines_count = 4
      @row_count = 4
      @col_count = 3

      @player = Player.new(lives: 1)
      @grid = Grid.build(@row_count, @col_count) do |row, col|
        Cell.new(col, row)
      end

      @grid.add_observer(@player)
    end

    def start
      drop_mines

      display_grid

      loop do
        command = controller.get_command
        command.execute(grid)

        display_grid

        break if over?
      end

      if game_won?
        display_win_message
      else
        display_lost_message
      end
    end

    private
      def over?
        player.dead? || mines_located?
      end

      def game_won?
        player.alive?
      end

      def mines_located?
        grid.cells.select(&:hidden?).all?(&:mined?)
      end

      def drop_mines
        grid.sample(mines_count).each do |cell|
          cell.put_mine
          # puts cell.inspect

          grid.get_neighbours(cell)
              .each(&:warn!)
        end
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
  end
end
