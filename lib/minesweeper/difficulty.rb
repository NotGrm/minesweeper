module Minesweeper
  Difficulty = Data.define(:mines_count, :row_count, :col_count) do
    BEGINNER = new(10, 9, 9)
    INTERMEDIATE = new(40, 16, 16)
    EXPERT = new(99, 16, 30)

    def self.find(difficulty)
      case difficulty
      when :beginner
        BEGINNER
      when :intermediate
        INTERMEDIATE
      when :expert
        EXPERT
      else
        raise "Invalid difficulty"
      end
    end
  end
end
