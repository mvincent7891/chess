module Slideable

  def get_valid_moves
    all_moves = []
    @moves.each do |move|
      flag = true
      current_pos = @pos.dup
      while flag
        next_pos = vector_addition(current_pos, move)
        if enemy_present?(next_pos)
          all_moves << next_pos
          flag = false
        elsif valid_move?(next_pos)
          all_moves << next_pos
          current_pos = next_pos
        else
          flag = false
        end
      end
    end

    all_moves
  end

end
