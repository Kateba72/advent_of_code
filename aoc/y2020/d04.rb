require_relative '../solution'

module AoC
  module Y2020
    class D04 < Solution

      def part1
        input = parse_input
        required = %w[byr iyr eyr hgt hcl ecl pid]

        input.count do |passport|
          required.all? { passport.include? _1 }
        end
      end

      def part2
        input = parse_input
        required = %w[byr iyr eyr hgt hcl ecl pid]

        input.count do |passport|
          next unless required.all? { passport.include? _1 }
          next unless passport['byr'] =~ /^\d{4}$/ && Regexp.last_match[0].to_i.in?(1920..2002)
          next unless passport['iyr'] =~ /^\d{4}$/ && Regexp.last_match[0].to_i.in?(2010..2020)
          next unless passport['eyr'] =~ /^\d{4}$/ && Regexp.last_match[0].to_i.in?(2020..2030)
          next unless (passport['hgt'] =~ /^(\d{3})cm$/ && Regexp.last_match[1].to_i.in?(150..193)) ||
            (passport['hgt'] =~ /^(\d{2})in$/ && Regexp.last_match[1].to_i.in?(59..76))
          next unless passport['hcl'] =~ /^#[0-9a-f]{6}$/
          next unless passport['ecl'].in? %w[amb blu brn gry grn hzl oth]
          next unless passport['pid'] =~ /^\d{9}$/

          true
        end
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n\n").map do |line|
          line.split.to_h do |part|
            part.split(':')
          end
        end
      end

      def get_test_input(_number)
        <<~TEST
          pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
          hcl:#623a2f

          eyr:2029 ecl:blu cid:129 byr:1989
          iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

          hcl:#888785
          hgt:164cm byr:2001 iyr:2015 cid:88
          pid:545766238 ecl:hzl
          eyr:2022

          iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 4
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D04.new(test: test)
  today.run
end
