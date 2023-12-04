import 'dart:io';

const test =
    '''Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11''';

void main() {
  List<String> input = test.split('\n');
  input = new File('input_4.txt').readAsLinesSync();

  Stopwatch stopwatch = new Stopwatch()..start();

  // we start with no copies (so 1 card)
  List<int> cardCount = List<int>.filled(input.length, 1);

  int scorePart1 = 0;
  int current = 0;
  for (var (first, second) in parseInput(input)) {
    Set<int> f = first.toSet();
    Set<int> s = second.toSet();
    var matching = f.intersection(s).length;

    for (int i = 1; i <= matching; i++) {
      // The aoc description states that this will not overflow the array
      cardCount[current + i] += cardCount[current];
    }

    if (matching > 0) {
      scorePart1 += 1 << (matching - 1);
    }

    current += 1;
  }

  var scorePart2 = cardCount.reduce((a, b) => a + b);

  stopwatch.stop();

  print('Part 1: $scorePart1');
  print('Part 2: $scorePart2');
  print('Time:   ${stopwatch.elapsedMicroseconds} us');
}

Iterable<(Iterable<int>, Iterable<int>)> parseInput(List<String> lines) sync* {
  for (String line in lines) {
    List<String> parts = line.split(':')[1].split('|');
    Iterable<int> first = parsePart(parts[0]);
    Iterable<int> second = parsePart(parts[1]);
    yield (first, second);
  }
}

Iterable<int> parsePart(String part) {
  return part.trim().split(' ').where((e) => e != '').map((e) => int.parse(e));
}
