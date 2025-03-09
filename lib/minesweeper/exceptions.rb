module Minesweeper
  module Exceptions
    Error = Class.new(StandardError)

    CellNotFound = Class.new(Error)
  end
end
