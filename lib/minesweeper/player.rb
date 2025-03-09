class Player
  attr_reader :lives

  def initialize(lives: 3)
    @lives = lives
  end

  def dead? = lives.zero?
  def alive? = !dead?

  def boom!(damages = 1)
    @lives -= damages
  end

  def on_notify(event)
    case event
    when Grid::MINE_REVEALED
      boom!
    end  
  end
end
