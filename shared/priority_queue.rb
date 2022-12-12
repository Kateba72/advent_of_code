# https://gist.github.com/PaulSanchez/a68e2b40af587dc968615f73c446e1e5
class PriorityQueue
  attr_reader :elements

  def initialize
    clear
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  alias push <<

  def peek
    @elements[1]
  end

  def pop
    max = @elements[1]
    bubble_down_and_replace(1)
    max
  end

  def clear
    @elements = [nil]
  end

  def empty?
    @elements.length < 2
  end

  private

  def bubble_up(index)
    target = @elements[index]
    loop do
      parent_index = index / 2
      if parent_index < 1 || (@elements[parent_index] <=> target) >= 0
        @elements[index] = target
        return
      end

      @elements[index] = @elements[parent_index]
      index = parent_index
    end
  end

  def bubble_down_and_replace(index)
    target = @elements.pop

    return if index >= @elements.size

    loop do
      child_index = (index * 2)

      if child_index > @elements.size - 1 && index < @elements.size
        @elements[index] = target
        return
      end

      not_the_last_element = child_index < @elements.size - 1
      left_element = @elements[child_index]
      right_element = @elements[child_index + 1]
      child_index += 1 if not_the_last_element && (right_element <=> left_element) == 1

      if (target <=> @elements[child_index]) >= 0
        @elements[index] = target
        return
      end

      @elements[index] = @elements[child_index]
      index = child_index
    end
  end
end
