require "optparse"

require_relative "cli/controller"
require_relative "cli/graphics"

module Minesweeper
  class CLI
    def self.start(args)
      new(args).run
    end

    def initialize(args)
      @args = args
      @options = {
        difficulty: :beginner
      }

      @option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: minesweeper [options]"

        opts.on("-v", "--verbose", "Display the version") do
          @options[:version] = true
        end

        opts.on("-h", "--help", "Display help") do
          @options[:help] = true
        end

        opts.on("--intermediate", "Play on intermediate difficulty") do
          @options[:difficulty] = :intermediate
        end

        opts.on("--expert", "Play on expert difficulty") do
          @options[:difficulty] = :expert
        end
      end
    end

    def run
      parse_options

      if @options[:version]
        display_version
        exit
      elsif @options[:help]
        display_help
        exit
      else
       start_game
      end
    rescue OptionParser::InvalidOption => e
      puts "Error: #{e.message}"
      display_help
    end

    private
      def parse_options
        @option_parser.parse!(@args)
      end

      def display_version
        puts "Minesweeper version #{Minesweeper::VERSION}"
      end

      def display_help
        puts @option_parser
      end

      def start_game
        Game.new(
          @options[:difficulty],
          Graphics.new,
          Controller
        ).start
      end
  end
end
