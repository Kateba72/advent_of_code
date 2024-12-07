require_relative '../solution'

module AoC
  module Y2020
    class D21 < Solution

      def part1
        input = parse_input

        allergen_possibilities = {}
        input.each do |line|
          line[1].each do |allergen|
            if allergen_possibilities.include? allergen
              allergen_possibilities[allergen] = allergen_possibilities[allergen] & line[0]
            else
              allergen_possibilities[allergen] = line[0].to_set
            end
          end
        end

        possibly_allergen = allergen_possibilities.values.map(&:to_a).flatten.to_set
        input.sum do |line|
          line[0].count { possibly_allergen.exclude? _1 }
        end
      end

      def part2
        input = parse_input

        allergen_possibilities = {}
        input.each do |line|
          line[1].each do |allergen|
            if allergen_possibilities.include? allergen
              allergen_possibilities[allergen] = allergen_possibilities[allergen] & line[0]
            else
              allergen_possibilities[allergen] = line[0].to_set
            end
          end
        end

        fixed_allergens = {}

        while allergen_possibilities.present?
          allergen_possibilities.each do |allergen, possibilities|
            possibilities -= fixed_allergens.keys
            if possibilities.size == 1
              ingredient = possibilities.first
              fixed_allergens[ingredient] = allergen
              allergen_possibilities.delete allergen
            end
          end
        end

        fixed_allergens.to_a.sort_by(&:second).map(&:first).join(',')
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      memoize def parse_input
        get_input.split("\n").map do |line|
          ingredients, allergens = line.split ' (contains '
          [ingredients.split, allergens.delete_suffix(?)).split(', ')]
        end
      end

      def get_test_input(number)
        <<~TEST
          mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
          trh fvjkl sbzzf mxmxvkd (contains dairy)
          sqjhc fvjkl (contains soy)
          sqjhc mxmxvkd sbzzf (contains fish)
        TEST
      end

      AOC_YEAR = 2020
      AOC_DAY = 21
    end
  end
end

if __FILE__ == $0
  test = ENV['TEST'] || ARGV.include?('--test') || ARGV.include?('-t') || ARGV.include?('test') || ARGV.include?('t')
  today = AoC::Y2020::D21.new(test: test)
  today.run
end
