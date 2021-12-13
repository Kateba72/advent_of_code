require_relative '../aoc_defaults'

def part1
  puts 'Part 1:'
  instructions = get_input

  memory = {}
  mask = {}

  instructions.each do |instruction|
    if m = instruction.match(/^mask = ([10X]+)$/)
      mask = parse_mask(m[1])
    elsif m = instruction.match(/^mem\[(\d+)\] = (\d+)$/)
      value = apply_bitmask(m[2].to_i, mask)
      memory[m[1].to_i] = value
    else
      puts "Unknown instruction:"
      puts instruction
    end
  end
  puts memory.sum { |k, v| v }

end

def part2
  puts 'Part 2:'
  instructions = get_input

  memory = {}
  mask = {}

  instructions.each do |instruction|
    if m = instruction.match(/^mask = ([10X]+)$/)
      mask = parse_mask(m[1])
    elsif m = instruction.match(/^mem\[(\d+)\] = (\d+)$/)
      value = m[2].to_i
      apply_floating_bitmask(m[1].to_i, mask).each do |address|
        memory[address] = value
      end
    else
      puts "Unknown instruction:"
      puts instruction
    end
  end
  puts memory.sum { |k, v| v }

end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(2020, 14)
  input.split("\n")
end

def parse_mask(mask)
  mask_zeroes = 0
  mask_ones = 0
  mask_floating = []
  mask.chars.each_with_index do |char, index|
    if char == '0'
      mask_zeroes |= 2 ** (35 - index)
    elsif char == '1'
      mask_ones |= 2 ** (35 - index)
    elsif char == 'X'
      mask_floating << 2 ** (35 - index)
    end
  end
  mask_zeroes = 2**36 - 1 - mask_zeroes
  {zeroes: mask_zeroes, ones: mask_ones, floating: mask_floating}
end

def apply_bitmask(int, mask)
  (int | mask[:ones]) & mask[:zeroes]
end

def apply_floating_bitmask(int, mask)
  values = [ (int | mask[:ones]) ]
  mask[:floating].each do |floating|
    values += values.map do |value|
      value & floating != 0 ? value - floating : value + floating
    end
  end
  values
end

def get_test_input(test)
  {1 => <<~TEST1, 2 => <<~TEST2}[test]
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  TEST1
  mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1
  TEST2
end

if __FILE__ == $0
  part1
  puts
  part2
end
