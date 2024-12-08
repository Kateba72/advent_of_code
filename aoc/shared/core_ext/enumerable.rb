module Enumerable
  alias in_chunks each_slice

  def lcm
    inject(:lcm)
  end

  def multiply
    inject(1, :*)
  end
end
