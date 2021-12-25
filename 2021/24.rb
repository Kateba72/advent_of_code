require_relative '../aoc_defaults'
# require 'matrix'

def part1
  puts 'Part 1:'
  input = get_input

  max_input = parse_alu_multiverse(input)

  p max_input
end

def part2
  puts 'Part 2:'
  input = get_input

  min_input = parse_alu_multiverse(input, false)

  p min_input

end

def parse_alu(program, input)
  variables = {w: 0, x: 0, y: 0, z: 0}.with_indifferent_access
  program.each do |line|
    parts = line.split(' ')
    case parts[0]
    when 'inp'
      variables[parts[1]] = input.pop(0).to_i
    when 'add'
      variables[parts[1]] += variables[parts[2]] || parts[2].to_i
    when 'mul'
      variables[parts[1]] *= variables[parts[2] || parts[2].to_i]
    when 'div'
      return nil if variables[parts[2]] == 0
      variables[parts[1]] /= variables[parts[2] || parts[2].to_i]
    when 'mod'
      return nil if variables[parts[1]] < 0 || variables[parts[2]] <= 0
      variables[parts[1]] %= variables[parts[2] || parts[2].to_i]
    when 'eql'
      variables[parts[1]] = variables[parts[1]] == (variables[parts[2]] || parts[2].to_i) ? 1 : 0
    end
  end

  variables
end

def parse_alu_multiverse(program, max=true)
  multiverses = {0 => 0}
  program.each do |part|
    m = part.match /mul x 0\nadd x z\nmod x 26\ndiv z (1|26)\nadd x (-?\d+)\neql x w\neql x 0\nmul y 0\nadd y 25\nmul y x\nadd y 1\nmul z y\nmul y 0\nadd y w\nadd y (\d+)\nmul y x\nadd z y/
    byebug unless m
    new_multiverses = {}
    multiverses.each do |z, max_input|
      (1..9).each do |w|
        x = (z % 26 + m[2].to_i) == w ? 0 : 1
        new_z = z / m[1].to_i
        y = 25 * x + 1
        new_z *= y
        y = (w + m[3].to_i) * x
        new_z += y

        next if z > 26**5

        unless (max && new_multiverses[new_z]&.>=(max_input * 10 + w)) || (!max && new_multiverses[new_z]&.<=(max_input * 10 + w))
          new_multiverses[new_z] = max_input * 10 + w
        end
      end
    end
    multiverses = new_multiverses
  end

  multiverses[0]
end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(2021, 24)
  input.split("\ninp w\n")
end

def get_test_input(number)
  <<~TEST
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
