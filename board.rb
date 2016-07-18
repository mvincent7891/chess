require_relative "display"
require_relative "pieces"

class Board
  attr_reader :display
  attr_accessor :test_moves

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    @display = Display.new(self)
    @test_moves = []
    populate
  end

  def populate
    set_pawns(:black)
    set_pawns(:white)
  end

  def set_pawns(color)
    row = color == :black ? 1 : 6
    @grid[row].each_index do |col|
      pos = [row, col]
      self[pos] = Pawn.new(self, color, pos)
    end
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
# pos_test = [3,5]
# test2 = [3,4]
# b[pos_test] = Pawn.new(b, :white, pos_test)
# b[pos_test].en_passant = true
# b[test2] = Pawn.new(b, :black, test2)
# b.test_moves = b[test2].get_valid_moves
b.display.render
# while true
#   from_pos, to_pos = nil, nil
#   until from_pos && to_pos
#     b.display.render
#     if from_pos
#       to_pos = b.display.get_input
#     else
#       from_pos = b.display.get_input
#     end
#   end
  # b.move(from_pos, to_pos)
  # b.display.render
# end
