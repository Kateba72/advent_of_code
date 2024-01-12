require_relative '../solution'

module AoC
  module Y2021
    class D19 < Solution

      def part1
        input = parse_input

        map = assemble_map(input)
        map[:beacons].size
      end

      def part2
        scanners = parse_input
        map = assemble_map(scanners)

        scanner_distances = map[:scanners].product(map[:scanners]).map do |scanner1, scanner2|
          scanner1.p_norm_to_p(scanner2, 1)
        end
        scanner_distances.max
      end

      def initialize(test: false, test_input: nil)
        @test = test
        @test_input = test_input
      end

      private

      def assemble_map(scanners)
        return @map if @map

        distances = scanners.map do |scanner|
          get_distances(scanner)
        end

        merged = 0
        did_something = true
        while merged < scanners.size - 1 #find overlapping distances and try to merge if successful
          did_something = false
          scanners.each_with_index do |scanner1, index1|
            next if scanner1[:merged]

            scanners[index1 + 1 ..].each_with_index do |scanner2, index2|
              next if scanner2[:merged]
              index2 += index1 + 1

              if try_to_merge(scanners, distances, index1, index2)
                merged += 1
                did_something = true
              end
            end
          end
          byebug unless did_something
        end

        @map = scanners[0]
      end

      def try_to_merge(scanners, distances, index1, index2)
        merged_distances = distances[index1].keys & distances[index2].keys
        return if merged_distances.size <= 55 # We expect 66 distinct distances, but there might be some overlap

        possible_matches = Hash.new(0)

        merged_distances.each do |merged_distance|
          appearing2 = []
          distances[index2][merged_distance].each do |b1, b2|
            appearing2 << b1
            appearing2 << b2
          end.uniq

          distances[index1][merged_distance].each do |b1, b2|
            appearing2.each do |o2|
              possible_matches[[b1, o2]] += 1
              possible_matches[[b2, o2]] += 1
            end
          end
        end

        possible_matches.reject! { |k, v| v < 11 }

        return if possible_matches.size < 12

        conversion = get_conversion(possible_matches.keys)
        return unless conversion

        scanners[index2][:merged] = true
        scanners[index2][:beacons].each do |beacon2|
          beacon1 = apply_conversion(conversion, beacon2)
          scanners[index1][:beacons] << beacon1 unless scanners[index1][:beacons].include?(beacon1)
        end
        scanners[index2][:scanners].each do |scanner2|
          scanner1 = apply_conversion(conversion, scanner2)
          scanners[index1][:scanners] << scanner1 unless scanners[index1][:scanners].include?(scanner1)
        end
        distances[index1] = get_distances(scanners[index1])

        true
      end

      def get_distances(scanner)
        scanner_distances = {}
        scanner[:beacons].each_with_index do |beacon1, index|
          scanner[:beacons][0...index].each do |beacon2|
            p_norm = beacon1.p_norm_to_p(beacon2, 4)
            scanner_distances[p_norm] ||= []
            scanner_distances[p_norm] << [beacon1, beacon2]
          end
        end
        scanner_distances
      end

      def get_conversion(pairs)
        good_pair = pairs[1..].find { |pair| (pairs[0][0] - pair[0]).to_a.map(&:abs).uniq.size == 3 }
        differences1 = (pairs[0][0] - good_pair[0]).to_a
        differences2 = (pairs[0][1] - good_pair[1]).to_a
        rot_matrix = Matrix.zero(3)
        differences1.each_with_index do |value, index1|
          if index2 = differences2.index(value)
            rot_matrix[index1, index2] = 1
          elsif index2 = differences2.index(-value)
            rot_matrix[index1, index2] = -1
          end
        end
        return unless rot_matrix.determinant == 1
        translation = pairs[0][0] - rot_matrix * pairs[0][1]

        [rot_matrix, translation]
      end

      def apply_conversion(conversion, vector)
        conversion[0] * vector + conversion[1]
      end

      def parse_input
        scanners = get_input.split("\n\n")
        scanners.map do |scanner|
          lines = scanner.split("\n")
          h = {}
          h[:number] = lines.first.match(/--- scanner (\d+) ---/)[1].to_i
          h[:merged] = false
          h[:scanners] = [Vector[0, 0, 0]]
          h[:beacons] = lines[1..].map do |line|
            line.match /(-?\d+),(-?\d+),(-?\d+)/ do |m|
              Vector[m[1].to_i, m[2].to_i, m[3].to_i]
            end
          end
          h
        end
      end

      def get_test_input(number)
        <<~TEST
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
        TEST
      end

      AOC_YEAR = 2021
      AOC_DAY = 19
    end
  end
end

if __FILE__ == $0
  today = AoC::Y2021::D19.new(test: false)
  today.run
end
