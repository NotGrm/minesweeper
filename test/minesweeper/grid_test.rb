require "test_helper"

class GridTest < Minitest::Test
  def assert_same_elements(expected, actual, message = nil)
    assert_equal expected.size, actual.size, message
    assert_empty expected.difference(actual), message
  end

  def test_build_grid
    grid = Grid.build(2, 2) do
      0
    end

    assert_equal [[0, 0], [0, 0]], grid.matrix
  end

  def test_get_cell_neighbours
    grid = Grid.build(3, 3) do |row, col|
      Cell.new(col, row)
    end

    assert_same_elements [
      grid.find(0, 0), # top_left_corner
      grid.find(1, 0), # top_center
      grid.find(2, 0), # top_right_corner
      grid.find(0, 1), # middle_left
      grid.find(2, 1), # middle_right
      grid.find(0, 2), # bottom_left_corner
      grid.find(1, 2), # bottom_center
      grid.find(2, 2), # bottom_right_corner
    ], grid.get_neighbours(grid.find(1, 1)), "center"

    assert_same_elements [
      grid.find(1, 0), # top_center
      grid.find(0, 1), # middle_left
      grid.find(1, 1), # center
    ], grid.get_neighbours(grid.find(0, 0)), "top_left_corner"

    assert_same_elements [
      grid.find(1, 0), # top_center
      grid.find(2, 1), # middle_right
      grid.find(1, 1), # center
    ], grid.get_neighbours(grid.find(2, 0)), "top_right_corner"

    assert_same_elements [
      grid.find(1, 2), # bottom_center
      grid.find(2, 1), # middle_right
      grid.find(1, 1), # center
    ], grid.get_neighbours(grid.find(2, 2)), "bottom_right_corner"

    assert_same_elements [
      grid.find(1, 2), # bottom_center
      grid.find(0, 1), # middle_left
      grid.find(1, 1), # center
    ], grid.get_neighbours(grid.find(0, 2)), "bottom_left_corner"
  end
end
