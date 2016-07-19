require 'byebug'
require_relative "display"
require_relative "pieces"

class Board
  attr_reader :display, :grid
  attr_accessor :test_moves

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    @display = Display.new(self)
    @test_moves = []
    # populate
  end

  def populate
    set_pawns(:black)
    set_pawns(:white)
    set_back_row(:black)
    set_back_row(:white)
  end

  BACK_ROW = [:Rook, :Knight, :Bishop, :King, :Queen, :Bishop, :Knight, :Rook]
  def set_back_row(color)
    row = color == :black ? 0 : 7
    @grid[row].each_index do |col|
      pos = [row, col]
      self[pos] = eval(BACK_ROW[col].to_s + ".new(self, color, pos)")
    end
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

  def dup
    duplicate_board = Board.new

    self.grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        pos = [i,j]
        if self[pos].is_a?(NullPiece)
          duplicate_board[pos] = NullPiece.instance
        else
          duplicate_board[pos] = self[pos].dup
        end
      end
    end

    duplicate_board
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

  def in_check?(color)
    king_pos = find_king(color)
    opponent_pieces = @grid.flatten.select { |piece| piece.color == opposite_color(color) }
    debugger
    opponent_pieces.any? {|piece| piece.valid_moves_prime.include?(king_pos)}
  end

  def opposite_color(color)
    color == :white ? :black : :white
  end

  def find_king(color)
    king_piece = @grid.flatten.select.with_index do |piece, i|
      piece.color == color && piece.is_a?(King)
    end
    king_piece[0].pos
  end

end

b = Board.new
b[[0,0]] = King.new(b, :white, [0,0])
b[[1,7]] = Queen.new(b, :black, [1,7])
c = b.dup
c[[0,0]], c[[1,0]] = c[[1,0]], c[[0,0]]
p c.find_king(:white)

# p b[[0,0]].valid_moves


# pos_test = [3,5]
# test2 = [3,4]
# b[pos_test] = Pawn.new(b, :white, pos_test)
# b[pos_test].en_passant = true
# b[test2] = Pawn.new(b, :black, test2)
# b.test_moves = b[test2].get_valid_moves

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
#   b.move(from_pos, to_pos)
#   b.display.render
# end
