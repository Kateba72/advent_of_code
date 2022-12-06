require_relative '../../2022/day6'

RSpec.describe Day6 do
  let(:test_input) { <<~TEST_INPUT }
    mjqjpqmgbljsphdztnvjfqwrcgsmlb
  TEST_INPUT

  subject { described_class.new(test_input: test_input) }

  describe '#part1' do
    it 'returns the position of the start of packet marker' do
      expect(subject.part1).to eq 7
    end
  end

  describe '#start_marker' do
    it 'returns the position of the start of packet marker' do
      expect(subject.send(:start_marker, 'bvwbjplbgvbhsrlpgdmjqwftvncz', 4)).to eq 5
      expect(subject.send(:start_marker, 'nppdvjthqldpwncqszvftbrmjlhg', 4)).to eq 6
      expect(subject.send(:start_marker, 'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 4)).to eq 10
      expect(subject.send(:start_marker, 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 4)).to eq 11
    end

    it 'returns the position of the start of message marker' do
      expect(subject.send(:start_marker, 'bvwbjplbgvbhsrlpgdmjqwftvncz', 14)).to eq 23
      expect(subject.send(:start_marker, 'nppdvjthqldpwncqszvftbrmjlhg', 14)).to eq 23
      expect(subject.send(:start_marker, 'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 14)).to eq 29
      expect(subject.send(:start_marker, 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 14)).to eq 26

    end
  end

  describe '#part2' do
    it 'returns the position of the start of message marker' do
      expect(subject.part2).to eq 19
    end
  end
end
