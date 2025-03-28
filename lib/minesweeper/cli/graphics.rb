require 'tty-table'

module Minesweeper
  class CLI
    class Graphics
      def display_grid(grid)
        table = TTY::Table.new(
          header: table_headers(grid),
          rows: grid.rows.map.with_index do |row, index|
            table_row(row, index)
          end
        )

        renderer = TTY::Table::Renderer::Unicode.new(
          table,
          alignments: [:right, :center],
          width: 999, # Ensure expert table is not truncated
          column_widths: 3,
          border: { separator: :each_row }
        )

        puts renderer.render
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
        def table_headers(grid)
          headers = [" "] # Empty header to leave space for rows headers

          grid.column_count.times do |index|
            value = (index + 1)
            alignment = value > 9 ? :right : :center
            headers << { value:, alignment: }
          end

          headers
        end

        # @param [Array<Cell>] row
        # @param [Integer] index
        def table_row(cells, index)
          row = [{value: index + 1, alignment: :right}] # Row header

          cells.each do |cell|
            row << { value: build_cell(cell), alignment: :center}
          end

          row
        end

        def build_cell(cell)
          case
          when cell.flagged?
            "F"
          when cell.hidden?
            "?"
          when cell.mined?
            "X"
          when cell.near_mine?
            "#{cell.adjacent_mines_count}"
          else
            "."
          end
      end
    end
  end
end
