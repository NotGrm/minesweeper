module Action
  class Defuse
    attr_reader :coords
    
    def initialize(user_input)
      @user_input = user_input

      @coords = user_input.scan(/\d+/).map(&:to_i)
    end
  end
end
