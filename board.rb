require_relative "display"
require_relative "pieces"

class Board
  attr_reader :display

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    @display = Display.new(self)
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

  def move(start, end_pos)
    self[end_pos], self[start] = self[start], self[end_pos]
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end

  def render
    @display.render
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

end

b = Board.new
b[[0,0]] = Piece.new
while true
  from_pos, to_pos = nil, nil
  until from_pos && to_pos
    b.display.render
    if from_pos
      to_pos = b.display.get_input
    else
      from_pos = b.display.get_input
    end
  end
  b.move(from_pos, to_pos)
  b.display.render
end
