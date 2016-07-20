require_relative 'stepable'
require 'byebug'

class King < Piece

  attr_accessor :string

  MOVES = [[1,0], [0,-1], [0,1], [-1,0], [1,1], [1,-1], [-1,-1], [-1,1]]
  CASTLE_MOVES = [[0,-2], [0,2]]

  def initialize(board, color, pos)
    @moves = MOVES
    @castle_moves = CASTLE_MOVES
    @string = nil
    super
    @at_start_row = true
  end

  def to_s
    @string || " " + ("\u265A").encode('utf-8') + " "
  end

  def get_valid_moves
    all_moves = []
    @moves.each do |move|
      current_pos = @pos.dup
      next_pos = vector_addition(current_pos, move)
      if enemy_present?(next_pos)
        all_moves << next_pos
      elsif valid_move?(next_pos)
        all_moves << next_pos
      end
    end
    castle_moves = @at_start_row ? castle : []
    all_moves + castle_moves
  end

  def castle
    moves = []
    @castle_moves.each do |move|
      condition = spaces_empty?(move) && rook?(move) && not_check?(move)
      moves << vector_addition(@pos, move) if condition
    end
    moves
  end

  def not_check?(move)
    delta = move[1] < 0 ? -1 : 1
    row = @pos[0]
    next_space = [row, @pos[1] + delta]
    dup_board = @board.dup
    dup_board.move!(@pos, next_space)
    !dup_board.in_check?(@color)
  end

  def rook?(move)
    corner = move[1] < 0 ? 0 : 7
    row = @pos[0]
    piece = @board[[row,corner]]
    # is a rook
    is_rook = piece.is_a?(Rook)
    # has not moved yet
    not_moved = piece.at_start_row

    is_rook && not_moved
  end

  def spaces_empty?(move)
    corner = move[1] < 0 ? 1 : 6
    row = @pos[0]
    if corner == 1
      (corner..(@pos[1] - 1)).to_a.each do |col|
        return false unless @board[[row,col]].empty?
      end
    else
      ((@pos[1] + 1)..corner).to_a.each do |col|
        return false unless @board[[row,col]].empty?
      end
    end
    true
  end

end
