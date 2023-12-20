module Enumerable
  alias_method :in_chunks, :each_slice

  def lcm
    inject(:lcm)
  end
end
