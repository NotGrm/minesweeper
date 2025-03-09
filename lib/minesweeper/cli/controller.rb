require_relative '../command'

module Minesweeper
  class CLI
    module Controller
      def self.get_command
        command = nil
        
        until command.is_a?(Command) do
          puts "What is your next command? (type h[elp] if you're lost)"
          print '> '

          input = gets.chomp
          command = parse_input(input)
        end

        command
      end

      private

      def self.parse_input(input)
        case input
        when /\A(?:reveal|r)\s+(\d+)\s+(\d+)\z/
          Command::Reveal.new(input)
        when /\A(?:flag|f)\s+(\d+)\s+(\d+)\z/
          Command::Flag.new(input)
        when /\A(?:guess|g)\s+(\d+)\s+(\d+)\z/
          Command::Guess.new(input)
        when "help"
          Command::Help.new(input)
        when "quit"
          Command::Quit.new(input)
        else
          nil
        end
      end
    end
  end
end
