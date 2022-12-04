require_relative '../../2022/day2'

RSpec.describe Day2 do
  let(:test_input) { <<~TEST_INPUT }
    A Y
    B X
    C Z
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    it 'gets the correct result for the test input' do
      expect(subject.part1).to eq 15
    end
  end

  describe '#part2' do
    it 'gets the correct result for the test input' do
      expect(subject.part2).to eq 12
    end
  end
end
