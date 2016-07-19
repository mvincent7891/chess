class Player

  attr_reader :name
  attr_accessor :color

  def initialize(name, board)
    @name = name
    @board = board
  end

  def get_input(message = nil)
    from_pos, to_pos = nil, nil
    message ||= "#{@name} it is your turn. You are #{@color[-5..-1]}."
    until from_pos && to_pos
      @board.test_moves = @board[from_pos].valid_moves if from_pos && !@board[from_pos].empty?
      @board.display.render
      puts message
      if from_pos
        puts "Move to where, #{@name}?"
        to_pos = @board.display.get_input
      else
        puts "Select #{@color[-5..-1]} piece, #{@name}:"
        from_pos = @board.display.get_input
      end
    end
    @board.test_moves = []
    [from_pos, to_pos]
  end

end

class ComputerPlayer < Player

  def get_input(message = nil)
    from_pos, to_pos = nil, nil
    pieces = get_pieces_with_moves
    random_piece = pieces.sample
    random_move = random_piece.valid_moves.sample
    [random_piece.pos, random_move]
  end

  def get_pieces_with_moves
    pieces = get_all_pieces
    pieces.select { |piece| piece.valid_moves.count > 0}
  end

  def get_all_pieces
    @board.grid.flatten.select { |piece| piece.color == @color }
  end

end
