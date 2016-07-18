require "singleton"

class NullPiece

  include Singleton

  def to_s
    "   "
  end

  def empty?
    true
  end

end
