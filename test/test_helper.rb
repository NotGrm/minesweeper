require 'minitest/autorun'
require 'minitest/reporters'

require 'debug'

Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new)

# Require your project’s main file so tests can access its classes and modules
require_relative '../lib/minesweeper'

