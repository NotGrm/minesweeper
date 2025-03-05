class Player
  attr_reader :lives

  def initialize(lives: 3)
    @lives = lives
  end

  def dead?
    lives.zero?
  end

  def boom!(damages = 1)
    @lives -= damages
  end
end
