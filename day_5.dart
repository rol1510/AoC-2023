import 'dart:io';
import 'dart:math';

const test = '''seeds: 55 13 79 14

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4''';

void main() {
  // List<String> input = test.split('\n\n');
  List<String> input = new File('input_5.txt').readAsStringSync().split('\n\n');

  var seeds = parseSeeds(input[0]);
  var allMaps = <RangeMap>[];

  for (int i = 1; i < input.length; i++) {
    allMaps.add(parseMap(input[i]));
  }

  Stopwatch sw = new Stopwatch()..start();
  var result1 = part1(seeds, allMaps);
  var result2 = part2(seeds, allMaps);
  sw.stop();

  print('Part 1: $result1');
  print('Part 2: $result2');
  print('Time:   ${sw.elapsedMicroseconds} us');
}

int part1(Iterable<int> seeds, List<RangeMap> allMaps) {
  int lowest = -1;
  for (final seed in seeds) {
    var current = seedToLocation(allMaps, seed);
    if (lowest == -1 || current < lowest) {
      lowest = current;
    }
  }
  return lowest;
}

int part2(Iterable<int> seeds, List<RangeMap> allMaps) {
  List<int> sl = seeds.toList();
  int lowest = -1;

  // iterate over the pairs of seeds and seed lengths
  for (int i = 0; i < sl.length - 1; i += 2) {
    var seed = sl[i];
    var seedLen = sl[i + 1];

    // print('seed: $seed, seedLen: $seedLen');

    var end = seed + seedLen;
    while (seed < end) {
      var (current, len) = seedToLocationLen(allMaps, seed);
      if (lowest == -1 || current < lowest) {
        lowest = current;
      }
      seed += len;
    }
  }

  return lowest;
}

int seedToLocation(List<RangeMap> allMaps, int seed) {
  int current = seed;
  for (final map in allMaps) {
    current = map.get(current);
  }
  return current;
}

// Returns the location and the number of seeds where the mapping will only be
// incremented by 1 for every seed.
(int, int) seedToLocationLen(List<RangeMap> allMaps, int seed) {
  int current = seed;
  int len = -1;
  for (final map in allMaps) {
    var range = map.getRange(current);
    current = range.$1;
    if (range.$2 == -1) {
      // result len is infinite, therefore the current len can stay the same.
    } else if (len == -1 || range.$2 < len) {
      len = range.$2;
    }
  }
  return (current, len);
}

Iterable<int> parseSeeds(String seeds) {
  return seeds.split(':')[1].trim().split(' ').map((e) => int.parse(e));
}

RangeMap parseMap(String map) {
  RangeMap rm = new RangeMap();
  Iterable<String> lines = map.split('\n').skip(1);
  for (String line in lines) {
    var parts = line.split(' ').map((e) => int.parse(e.trim()));
    rm.addMapping(parts.elementAt(1), parts.elementAt(0), parts.elementAt(2));
  }
  return rm;
}

class Mapping {
  int source;
  int dest;
  int len;

  Mapping(this.source, this.dest, this.len);

  bool indexInSouce(int index) {
    return index >= source && index < source + len;
  }

  int toDest(int index) {
    return index - source + dest;
  }

  int leftOverLen(int index) {
    return len - (index - source);
  }
}

class RangeMap {
  List<Mapping> mappings = <Mapping>[];

  void addMapping(int source, int dest, int len) {
    mappings.add(new Mapping(source, dest, len));
  }

  int get(index) {
    for (Mapping mapping in mappings) {
      if (mapping.indexInSouce(index)) {
        return mapping.toDest(index);
      }
    }
    return index;
  }

  // Returns the destination and the number of seeds where the mapping will only
  // be incremented by 1 for every seed.
  // len == -1 means the len is infinite
  (int, int) getRange(int index) {
    for (Mapping mapping in mappings) {
      if (mapping.indexInSouce(index)) {
        return (mapping.toDest(index), mapping.leftOverLen(index));
      }
    }

    // If the seed wasn't in any of the mappings, the len will be distance from
    // the seed to the next mapping source
    int smallest = -1;
    for (Mapping mapping in mappings) {
      if (mapping.source > index) {
        if (smallest == -1 || mapping.source < smallest) {
          smallest = mapping.source;
        }
      }
    }

    if (smallest == -1) {
      return (index, -1);
    } else {
      return (index, smallest - index);
    }
  }
}
