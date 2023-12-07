require_relative '../aoc_defaults'
# require 'matrix'

def part1
  puts 'Part 1:'
  template, rules = get_input

  pairs = Hash.new(0)
  template.each_with_index do |ch, i|
    if template[i+1]
      pair = ch + template[i+1]
      pairs[pair] += 1
    end
  end

  10.times do
    pairs = apply_rules(pairs, rules)
  end

  counts = Hash.new(0)
  pairs.each do |pair, count|
    counts[pair[0]] += count
  end
  counts[template[-1]] += 1

  puts counts.values.max - counts.values.min
end

def part2
  puts 'Part 2:'
  template, rules = get_input

  pairs = Hash.new(0)
  template.each_with_index do |ch, i|
    if template[i+1]
      pair = ch + template[i+1]
      pairs[pair] += 1
    end
  end

  40.times do
    pairs = apply_rules(pairs, rules)
  end

  counts = Hash.new(0)
  pairs.each do |pair, count|
    counts[pair[0]] += count
  end
  counts[template[-1]] += 1

  puts counts.values.max - counts.values.min
end

def apply_rules(pairs, rules)
  output_pairs = Hash.new(0)
  pairs.each do |pair, count|
    middle_char = rules[pair]
    output_pairs[pair[0] + middle_char] += count
    output_pairs[middle_char + pair[1]] += count
  end
  output_pairs
end

def get_input(test=false)
  input = test ? get_test_input(test) : get_aoc_input(2021, 14)
  template, rules = input.split("\n\n")
  rules = rules.split("\n").map do |rule|
    if m = rule.match(/([A-Z][A-Z]) -> ([A-Z])/)
      [m[1], m[2]]
    else
      throw "Invalid rule #{rule}"
    end
  end.to_h
  [template.chars, rules]
end

def get_test_input(number)
  <<~TEST
  NNCB

  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C
  TEST
end

if __FILE__ == $0
  part1
  puts
  part2
end
