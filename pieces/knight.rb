require_relative 'stepable'

class Knight < Piece
  MOVES = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]
  include Stepable
  def initialize(board, color, pos)
    @moves = MOVES
    super
  end

  def to_s
    " " + ("\u265E").encode('utf-8') + " "
  end


end
