class Cell
  attr_reader :x, :y, :mined, :adjacent_mines_count, :revealed

  def initialize(x, y)
    @x = x
    @y = y

    @mined = false
    @adjacent_mines_count = 0
    @revealed = false
  end

  alias mined? mined
  alias revealed? revealed

  def hidden? = !revealed?
  def near_mine? = adjacent_mines_count.positive?
  def blank? = !mined? && !near_mine?

  def put_mine
    @mined = true
  end

  def reveal!
    @revealed = true
  end

  def warn!
    @adjacent_mines_count += 1
  end

  def ==(other)
    other.is_a?(Cell) && other.x == x && other.y == y
  end

  def to_s
    case
    when hidden?
      " ? "
    when mined?
      " X "
    when near_mine?
      " #{adjacent_mines_count} " 
    else
      " · "
    end
  end

  def inspect
    "Cell(#{x + 1},#{y + 1})"
  end
end

