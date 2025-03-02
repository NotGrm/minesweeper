class Minesweeper
  attr_reader :column_count, :mines_count, :row_count, :grid

  def initialize(row_count, column_count, mines_count)
    @row_count = row_count
    @column_count = column_count
    @mines_count = mines_count

    @grid = Grid.build(row_count, column_count) do |row, col|
      Cell.new(col, row)
    end
  end

  def start!
    puts "Start new game with a #{row_count}x#{column_count} grid, and #{mines_count} mine(s)"
    
    grid.sample(mines_count).each do |cell| 
      cell.put_mine

      grid.get_neighbours(cell)
          .each(&:warn!)
    end

    loop do
      quit = false
      puts "Which case would you like to reveal?"

      command = gets.chomp

      case command
      when /\d,\d/
        reveal_cell *command.split(',').map(&:to_i)
      when "show"
        puts grid.draw
      when "reveal"
        reveal_grid
      when "quit"
        quit = true
      else
        puts "Unknown command: #(command)"
      end
      
      break if quit
    end
  end

  def reveal_cell(x, y)
    cell = grid.find(x - 1, y - 1)

    if cell
      cell.reveal!
      puts grid.draw
    else
      puts "Cell unknown please retry"
    end
  end
  
  def reveal_grid
    grid.each(&:reveal!)
    
    puts "The revealed grid"
    puts grid.draw
  end

  class Grid
    include Enumerable

    attr_reader :matrix, :cells

    def self.build(row_count, column_count)
      matrix = Array.new(row_count) do |row_index|
        Array.new(column_count) do |col_index|
          yield(row_index, col_index)
        end
      end

      new(matrix)
    end

    def initialize(matrix)
      @matrix = matrix
      @cells = matrix.flatten
    end

    def each(...)
      @cells.each(...)
    end

    def find(col, row)
      @matrix.dig(row, col)
    end

    def sample(count)
      @cells.sample(count)
    end

    def get_neighbours(cell)
      row = cell.y
      col = cell.x

      north = matrix.dig(row - 1, col) if (row - 1).positive?
      east = matrix.dig(row, col + 1)
      south = matrix.dig(row + 1, col)
      west = matrix.dig(row, col  - 1) if (col - 1).positive?

      [north, east, south, west].compact
    end 

    def draw
      @matrix.collect do |row|
        "|" + row.collect(&:to_s).join('|') + "|"
      end
    end
  end

  class Cell
    attr_reader :x, :y, :mined, :mined_neighbours_count, :revealed

    def initialize(x, y)
      @x = x
      @y = y

      @mined = false
      @mined_neighbours_count = 0
      @revealed = false
    end

    alias mined? mined
    alias revealed? revealed

    def hidden? = !revealed?

    def put_mine
      @mined = true
    end

    def reveal!
      @revealed = true
    end

    def warn!
      @mined_neighbours_count += 1
    end

    def to_s
      case
      when hidden?
        " ? "
      when mined?
        " X "
      when mined_neighbours_count.positive?
        " #{mined_neighbours_count} " 
      else
        " · "
      end
    end

    def inspect
      "Cell(#{x},#{y})"
    end
  end
end

game = Minesweeper.new(4, 3, 4)
game.start!
game.reveal_grid
