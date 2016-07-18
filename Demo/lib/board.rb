require_relative "piece"

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.new } }
  end

  def full?
    @grid.all? do |row|
      row.all? { |piece| piece.present? }
    end
  end

  def mark(pos)
    x, y = pos
    @grid[x][y] = Piece.new
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end
end
