module Minesweeper
  class CLI
    class Graphics
      def display_grid(grid)
        rendered = ""
        rendered << build_headers(grid)

        grid.rows.each_with_index do |row, index|
          rendered << build_row(row, index)
        end

        puts rendered
      end

      def display_success(success)
        display_message(success, "\\o/")
      end

      def display_error(error)
        display_message(error, "/!\\")
      end

      def display_message(msg, glyph = nil)
        message = ""
        message << "#{glyph} " if glyph
        message << msg

        puts message
      end

      private
        def build_headers(grid)
          rendered = ""
          rendered << "| + |" # Empty header to leave space for columns headers

          grid.column_count.times do |index|
            rendered << " #{index + 1} "
            rendered << "|"
          end

          rendered << "\n"

          rendered
        end

        # @param [Array<Cell>] row
        # @param [Integer] index
        def build_row(row, index)
          rendered = ""
          rendered << "| #{ index + 1} |"

          row.each do |cell|
            rendered << build_cell(cell)
            rendered << "|"
          end

          rendered << "\n"

          rendered
        end

        def build_cell(cell)
          case
          when cell.hidden?
            " ? "
          when cell.mined?
            " X "
          when cell.near_mine?
            " #{cell.adjacent_mines_count} "
          else
            " . "
          end
      end
    end
  end
end
