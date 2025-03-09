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

  alias rows matrix

  def column_count
    rows.first.size
  end

  def reveal_cell_and_neighbours(cell, visited = Set.new)
    return if visited.include?(cell)
    
    cell.reveal!

    return if cell.mined?
    return if cell.near_mine?
    
    visited << cell

    get_neighbours(cell).each do |neighbour|
      next if neighbour.mined?

      reveal_cell_and_neighbours(neighbour, visited)
    end
  end

  def reveal_all_cells!
    cells.each(&:reveal!)
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

    north = matrix.dig(row - 1, col) unless (row - 1).negative?
    east = matrix.dig(row, col + 1)
    south = matrix.dig(row + 1, col)
    west = matrix.dig(row, col  - 1) unless (col - 1).negative?

    [north, east, south, west].compact
  end 
end
