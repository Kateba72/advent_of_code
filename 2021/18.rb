require_relative '../aoc_defaults'
# require 'matrix'

def part1
  puts 'Part 1:'
  input = get_input

  magn = input[1..].inject(SnailfishNumber.new(input[0])) do |sum, x|
    sum + SnailfishNumber.new(x)
  end.magnitude
  puts magn
end

def part2
  puts 'Part 2:'
  input = get_input

  max = input.product(input).map do |x, y|
    next 0 if x == y
    (SnailfishNumber.new(x) + SnailfishNumber.new(y)).magnitude
  end.max
  puts max
end

class SnailfishNumber
  attr_accessor :number, :first, :last, :depth

  def initialize(arr, depth=0)
    arr = eval(arr) if String === arr
    arr = arr.number if SnailfishNumber === arr && arr.number?
    case arr
    when Integer
      @number = arr
      @first = nil
      @last = nil
    else
      @number = nil
      @first = SnailfishNumber.new(arr.first, depth + 1)
      @last = SnailfishNumber.new(arr.last, depth + 1)
    end
    @depth = depth
  end

  def +(other)
    SnailfishNumber.new([self, other]).reduce
  end

  def magnitude
    if pair?
      3 * first.magnitude + 2 * last.magnitude
    else
      number
    end
  end

  def to_s
    if number?
      number.to_s
    else
      "[#{self.first.to_s},#{self.last.to_s}]"
    end
  end

  def number?
    @number.present?
  end

  def pair?
    @first.present?
  end

  def reduce
    loop do
      did_something = explode || split
      break unless did_something
    end
    self
  end

  def explode
    return unless pair?

    if depth >= 4
      ret = [first.number, last.number]
      self.number = 0
      self.first = nil
      self.last = nil
      ret
    else
      if explosion = first.explode
        self.last.add_to_first(explosion[1]) if explosion[1] > 0
        [explosion[0], 0]
      elsif explosion = last.explode
        self.first.add_to_last(explosion[0]) if explosion[0] > 0
        [0, explosion[1]]
      else
        nil
      end
    end
  end

  def split
    if pair?
      first.split || last.split
    else
      if number >= 10
        self.first = SnailfishNumber.new(number / 2, depth + 1)
        self.last = SnailfishNumber.new((number + 1) / 2, depth + 1)
        self.number = nil
        true
      end
    end
  end

  def add_to_first(value)
    if number?
      self.number += value
    else
      self.first.add_to_first(value)
    end
  end

  def add_to_last(value)
    if number?
      self.number += value
    else
      self.last.add_to_last(value)
    end
  end
end

def get_input
  input = get_aoc_input(2021, 18)
  input.split("\n")
end

def do_tests
  def expect_to_eq(a, b)
    return if a.to_s == b.to_s
    puts
    puts 'Expected'
    puts "#{a} to eq"
    puts "#{b}"
    raise RuntimeError
  end

  expect_to_eq(
    SnailfishNumber.new([1, 2]) + SnailfishNumber.new([[3, 4], 5]),
    "[[1,2],[[3,4],5]]"
  )
  expect_to_eq(
    SnailfishNumber.new([[[[4,3],4],4],[7,[[8,4],9]]]) + SnailfishNumber.new([1,1]),
    "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
  )
  expect_to_eq(
    SnailfishNumber.new([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]).magnitude,
    3488
  )

  puts "tests successful"
end

if __FILE__ == $0
  do_tests
  part1
  puts
  part2
end
