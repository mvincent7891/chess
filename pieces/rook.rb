require_relative 'slideable'

class Rook < Piece
  MOVES = [[1,0], [0,-1], [0,1], [-1,0]]
  include Slideable
  def initialize(board, color, pos)
    @moves = MOVES
    super
  end


end
