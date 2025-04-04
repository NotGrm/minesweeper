require_relative 'exceptions'

class Grid
  include Enumerable

  CellNotFound = Class.new(StandardError)

  MINE_REVEALED = 'mined_reveal.grid'.freeze

  attr_reader :matrix, :cells, :observers

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
    @observers = []
  end

  alias rows matrix

  def add_observer(observer)
    observers << observer
  end

  def column_count
    rows.first.size
  end

  def reveal_cell(cell, visited = Set.new)
    return if visited.include?(cell)

    cell.reveal!

    if cell.mined?
      reveal_all_cells!
      notify(MINE_REVEALED)
    end

    return unless cell.blank?

    visited << cell

    get_neighbours(cell).each do |neighbour|
      next if neighbour.mined?

      reveal_cell(neighbour, visited)
    end
  end

  def flag_cell(cell)
    cell.toggle_flag!
  end

  def reveal_all_cells!
    cells.each(&:reveal!)
  end

  def find(col, row)
    @matrix.dig(row, col) || raise(CellNotFound)
  end

  def sample(count)
    @cells.sample(count)
  end

  def get_neighbours(cell)
    row = cell.y
    col = cell.x

    vectors = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

    vectors.filter_map do |vector|
      dest_row = row + vector[0]
      dest_col = col + vector[1]

      matrix.dig(dest_row, dest_col) if dest_row >= 0 && dest_col >= 0
    end

    # north = matrix.dig(row - 1, col) unless (row - 1).negative?
    # east = matrix.dig(row, col + 1)
    # south = matrix.dig(row + 1, col)
    # west = matrix.dig(row, col  - 1) unless (col - 1).negative?

    # [north, east, south, west].compact
  end

  def notify(event)
    observers.each do |obs|
      obs.on_notify(event)
    end
  end
end
