require 'byebug'
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
    # Choose Random
    # get_all_valid_moves.sample
    # Choose Random Attack
    choose_random_attack
  end

  def choose_random_attack
    moves = get_all_valid_moves
    attacks = moves.select { |move| @board[move[0]].enemy_present?(move[1])}
    attacks.count > 0 ? attacks.sample : moves.sample
  end

  def get_all_valid_moves
    pieces = get_pieces_with_moves
    all_valid_moves = []
    pieces.each do |piece|
      piece.valid_moves.each { |move| all_valid_moves << [piece.pos, move]}
    end
    all_valid_moves
  end

  def get_pieces_with_moves
    pieces = get_all_pieces
    pieces.select { |piece| piece.valid_moves.count > 0}
  end

  def get_all_pieces
    @board.grid.flatten.select { |piece| piece.color == @color }
  end

end
