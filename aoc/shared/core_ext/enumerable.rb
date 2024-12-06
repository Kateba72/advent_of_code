module Enumerable
  alias_method :in_chunks, :each_slice

  def lcm
    inject(:lcm)
  end

  def multiply
    inject(1, :*)
  end
end
