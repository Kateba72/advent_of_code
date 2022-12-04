require_relative '../../2022/day4'

RSpec.describe Day4 do
  let(:test_input) { <<~TEST_INPUT }
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    it 'counts all parts where one part is fully contained' do
      expect(subject.part1).to eq 2
    end
  end

  describe '#part2' do
    it 'counts all parts that overlap at all' do
      expect(subject.part2).to eq 4
    end
  end
end
