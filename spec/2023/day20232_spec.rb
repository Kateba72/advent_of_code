require_relative '../../2023/day20232'

RSpec.describe Day20232 do
  let(:test_input) { <<~TEST_INPUT }
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    it 'sums the number of all games doable with 12 red, 13 green, 14 blue' do
      expect(subject.part1).to eq 8
    end
  end

  describe '#part2' do
    it 'sums the powers of all sets' do
      expect(subject.part2).to eq 2286
    end
  end
end
