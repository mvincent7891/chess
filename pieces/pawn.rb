class Pawn < Piece

  DOWN = 1
  UP = -1

  def initialize(board, color, pos)

    @at_start_row = true
    @direction = pos[0] == 1 ? DOWN : UP
    @forward_moves = [[@direction * 2, 0], [@direction, 0]]
    @attacking_moves = [[@direction, 1],[@direction, -1]]
    super
  end

  def to_s
    " " + ("\u2659").encode('utf-8') + " "
  end

  def at_start_row?
    @at_start_row
  end

  def get_valid_moves
    valid_moves = []
    current_pos = @pos.dup

    @forward_moves.each_with_index do |move, index|
      next_pos = vector_addition(current_pos, move)
      next if index == 0 && !@at_start_row
      valid_moves << next_pos if valid_move?(next_pos)
    end

    @attacking_moves.each do |move|
      next_pos = vector_addition(current_pos, move)
      if enemy_present?(next_pos)
        valid_moves << next_pos
      elsif enemy_present?(vector_addition(next_pos, [-@direction, 0])) &&
        @board[vector_addition(next_pos, [-@direction, 0])].en_passant
        valid_moves << next_pos
      end
    end
    valid_moves
  end


end
