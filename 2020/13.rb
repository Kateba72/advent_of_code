require_relative '../aoc_defaults'

def part1
  puts 'Part 1:'
  earliest_time, departures = get_input
  earliest_time = earliest_time.to_i

  options = departures.split(',').map do |bus|
    next if bus == 'x'
    wait_time = (-earliest_time) % bus.to_i
    [wait_time, bus.to_i]
  end.compact

  wait_time, bus = options.min { |x, y| x.first <=> y.first }

  puts wait_time * bus
end

def part2
  puts 'Part 2:'
  departures = get_input[1].split(',').map.with_index do |bus, index|
    next if bus == 'x'
    [index, bus.to_i]
  end.compact

  prod = departures.reduce(1) { |p, x| p * x[1] }
  identities = departures.map do |departure|
    # solve s * bus + t * prod/bus = 1
    # and use t * (- index)
    a, b = departure[1], prod / departure[1]
    t, v = 0, 1

    while b > 0
      q = a / b
      a, b = b, a % b
      t, v = v, t - q * v
    end

     - t * departure[0] * prod / departure[1]
  end

  puts identities.sum % prod
end

def get_input(test=false)
  input = test ? get_test_input : get_aoc_input(2020, 13)
  input.split("\n")
end

def get_test_input
  <<~TEST
  939
  7,13,x,x,59,x,31,19
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
