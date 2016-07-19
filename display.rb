require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :red
    elsif @board.test_moves.include?([i,j])
      bg = :light_yellow
    elsif (i + j).odd?
      bg = :white
    else
      bg = :light_black
    end
    { background: bg, color: @board[[i,j]].color }
  end

  def render
    system("clear")
    build_grid.each { |row| puts row.join }
  end
end
