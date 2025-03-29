require 'pastel'
require 'tty-table'

module Minesweeper
  class CLI
    class Graphics
      def initialize
        pastel = Pastel.new

        @cell_outputs = {
          flagged: pastel.bright_yellow('🚩'),
          hidden: pastel.bright_white('⬜️'),
          mined: pastel.bright_red('💣'),
          one_mine_near: pastel.bright_cyan('1'),
          two_mines_near: pastel.bright_green('2'),
          three_mines_near: pastel.bright_red('3'),
          four_mines_near: pastel.bright_magenta('4'),
          none: ''
        }.freeze
      end

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
          column_widths: 2,
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
            alignment = :right
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
            @cell_outputs[:flagged]
          when cell.hidden?
            @cell_outputs[:hidden]
          when cell.mined?
            @cell_outputs[:mined]
          when cell.near_mine?
            case cell.adjacent_mines_count
            when 1
              @cell_outputs[:one_mine_near]
            when 2
              @cell_outputs[:two_mines_near]
            when 3
              @cell_outputs[:three_mines_near]
            when 4
              @cell_outputs[:four_mines_near]
            else
              cell.adjacent_mines_count.to_s
            end
          else
            @cell_outputs[:none]
          end
      end
    end
  end
end
