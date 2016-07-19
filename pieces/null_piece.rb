require "singleton"

class NullPiece
  attr_reader :en_passant, :color
  include Singleton

  def initialize
    @en_passant = false
    @color = :grey
  end

  def to_s
    "   "
  end

  def empty?
    true
  end

end
