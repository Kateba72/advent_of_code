require_relative '../../2020/day15'

RSpec.describe Day15 do
  describe '#nth_number' do
    it 'returns the correct result for all test cases' do
      expect(subject.send(:nth_number, 2020, [0, 3, 6])).to eq 436
      expect(subject.send(:nth_number, 2020, [1, 3, 2])).to eq 1
      expect(subject.send(:nth_number, 2020, [2, 1, 3])).to eq 10
      expect(subject.send(:nth_number, 2020, [1, 2, 3])).to eq 27
      expect(subject.send(:nth_number, 2020, [2, 3, 1])).to eq 78
      expect(subject.send(:nth_number, 2020, [3, 2, 1])).to eq 438
      expect(subject.send(:nth_number, 2020, [3, 1, 2])).to eq 1836
      expect(subject.send(:nth_number, 30000000, [0, 3, 6])).to eq 175594
    end
  end
end
