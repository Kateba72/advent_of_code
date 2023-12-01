require_relative '../../2023/day20231'

RSpec.describe Day20231 do

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    let(:test_input) { <<~TEST_INPUT }
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    TEST_INPUT

    it 'uses the first and the last digit' do
      expect(described_class.new(test_input: '1abc2').part1).to eq 12
      expect(described_class.new(test_input: 'pqr3stu8vwx').part1).to eq 38
      expect(described_class.new(test_input: 'a1b2c3d4e5f').part1).to eq 15
      expect(described_class.new(test_input: 'treb7uchet').part1).to eq 77
    end

    it 'sums all calibration values' do
      expect(subject.part1).to eq 142
    end
  end

  describe '#part2' do
    let(:test_input) { <<~TEST_INPUT }
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
    TEST_INPUT

    it 'can use spelled out digits' do
      expect(subject.part2).to eq 281
    end
  end
end
