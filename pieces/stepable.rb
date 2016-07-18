module Stepable

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
    all_moves
  end
end
