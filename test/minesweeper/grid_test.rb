require "test_helper"

class GridTest < Minitest::Test
  def test_build_grid
    grid = Grid.build(2, 2) do
      0
    end

    assert_equal [[0, 0], [0, 0]], grid.matrix
  end

  def test_get_cell_neighbours
    grid = Grid.build(4,4) do |row, col|
      Cell.new(col, row)
    end

    upper_left = grid.find(0, 0)
    upper_left_neighbours = grid.get_neighbours(upper_left)

    assert_equal 2, upper_left_neighbours.size   
    assert_equal [Cell.new(1, 0), Cell.new(0, 1)], upper_left_neighbours

    upper_right = grid.find(3, 0)
    upper_right_neighbours = grid.get_neighbours(upper_right)

    assert_equal 2, upper_right_neighbours.size
    assert_equal [Cell.new(3, 1), Cell.new(2, 0)], upper_right_neighbours
        
    lower_right = grid.find(3, 3)
    lower_right_neighbours = grid.get_neighbours(lower_right)

    assert_equal 2, lower_right_neighbours.size
    assert_equal [Cell.new(3, 2), Cell.new(2, 3)], lower_right_neighbours
        
    lower_left = grid.find(0, 3)
    lower_left_neighbours = grid.get_neighbours(lower_left)

    assert_equal 2, lower_left_neighbours.size
    assert_equal [Cell.new(0, 2), Cell.new(1, 3)], lower_left_neighbours

    middle = grid.find(1,1)
    middle_neighbours = grid.get_neighbours(middle)
    
    assert_equal 4, middle_neighbours.size
    assert_equal [
      Cell.new(1, 0),
      Cell.new(2, 1),
      Cell.new(1, 2),
      Cell.new(0, 1)
    ], middle_neighbours
  end
end
