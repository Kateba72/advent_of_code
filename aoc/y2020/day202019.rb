require_relative '../aoc_defaults'
require 'benchmark'
# require 'matrix'
require_relative 'scratch'

class Day202019
  include Memoized

  def part1
    texts = get_input

    texts.count do |text|
      text.size == get_length('0') && match(text.chars, '0')
    end
  end

  memoize def match(text, rule_no)
    rule = @rules[rule_no]
    if rule[0]
      text[0] == rule[0]
    else
      rule[1].any? do |rulepart|
        offset = 0
        rulepart.all? do |part|
          length = get_length(part)
          matches = match(text[offset...(offset + length)], part)
          offset += length
          matches
        end
      end
    end
  end

  memoize def get_length(rule_no)
    rule = @rules[rule_no]
    lengths = if rule[0]
      [1]
    else
      rule[1].map do |rulepart|
        rulepart.sum do |part|
          get_length(part)
        end
      end
    end

    raise "rule #{rule} has lengths #{lengths}" if lengths.uniq.size >= 2
    lengths[0]
  end

  def part2
    texts = get_input
    # Rule 8 and 11 are only used in rule 0, which is "8 11"
    # So a match now roughly equals 42 [42 ...] 42 31 [31 ...]
    # where the number of additional 42s must be greater or equal than the number of additional 31s
    # Both rules 42 and 31 have the same length
    chunk_size = get_length('42')
    raise unless get_length('31') == chunk_size
    texts.count do |text|
      next false unless text.size % chunk_size == 0
      forced_42_chunks = ((text.size / chunk_size) / 2 + 1).to_i
      switched_to_31 = false
      text.chars.in_chunks(chunk_size).with_index.all? do |chunk, index|
        if index < forced_42_chunks
          match(chunk, '42')
        elsif switched_to_31
          match(chunk, '31')
        elsif index == text.size / chunk_size - 1
          match(chunk, '31')
        elsif match(chunk, '42')
          true
        else
          switched_to_31 = true
          match(chunk, '31')
        end
      end
    end
  end

  def initialize(test: false, test_input: nil)
    @test = test
    @test_input = test_input
  end

  private

  memoize def get_input
    rules, texts = if @test_input.present?
      @test_input
    elsif @test
      get_test_input(@test)
    else
      get_aoc_input(2020, 19)
    end.split("\n\n").map { |x| x.split("\n") }
    @rules = rules.to_h do |line|
      no, parts = line.split(": ")
      is_single = parts.match?(/^"[ab]"$/) ? parts[1] : false
      [no, [is_single, parts.split(" | ").map { |part| part.split }]]
    end
    texts
  end

  def get_test_input(number)
    <<~TEST
      42: 9 14 | 10 1
      9: 14 27 | 1 26
      10: 23 14 | 28 1
      1: "a"
      11: 42 31
      5: 1 14 | 15 1
      19: 14 1 | 14 14
      12: 24 14 | 19 1
      16: 15 1 | 14 14
      31: 14 17 | 1 13
      6: 14 14 | 1 14
      2: 1 24 | 14 4
      0: 8 11
      13: 14 3 | 1 12
      15: 1 | 14
      17: 14 2 | 1 7
      23: 25 1 | 22 14
      28: 16 1
      4: 1 1
      20: 14 14 | 1 15
      3: 5 14 | 16 1
      27: 1 6 | 14 18
      14: "b"
      21: 14 1 | 1 14
      25: 1 1 | 1 14
      22: 14 14
      8: 42
      26: 14 22 | 1 20
      18: 15 15
      7: 14 5 | 1 21
      24: 14 1

      abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
      bbabbbbaabaabba
      babbbbaabbbbbabbbbbbaabaaabaaa
      aaabbbbbbaaaabaababaabababbabaaabbababababaaa
      bbbbbbbaaaabbbbaaabbabaaa
      bbbababbbbaaaaaaaabbababaaababaabab
      ababaaaaaabaaab
      ababaaaaabbbaba
      baabbaaaabbaaaababbaababb
      abbbbabbbbaaaababbbbbbaaaababb
      aaaaabbaabaaaaababaa
      aaaabbaaaabbaaa
      aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
      babaaabbbaaabaababbaabababaaab
      aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
    TEST
  end
end

if __FILE__ == $0
  today, part1, part2 = [nil, nil, nil]
  puts 'Day 19'
  Benchmark.bm(12) do |benchmark|
    benchmark.report('Setup') { today = Day202019.new }
    benchmark.report('Input parsing') { today.send(:get_input) }
    benchmark.report('Part 1') { part1 = today.part1 }
    benchmark.report('Part 2') { part2 = today.part2 }
  end
  puts
  puts 'Part 1:'
  puts part1
  puts
  puts 'Part 2:'
  puts part2
end
