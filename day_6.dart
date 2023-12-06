import 'dart:math';

const test = '''Time:      7  15   30
Distance:  9  40  200''';

const input =
    '''Time:        34     90     89     86
Distance:   204   1713   1210   1780''';

void main() {
  // List<String> inputPart1 = test.split('\n');
  // List<String> inputPart2 =
  //     test.replaceAll(' ', '').replaceAll(':', ': ').split('\n');

  Stopwatch sw = new Stopwatch()..start();

  List<String> inputPart1 = input.split('\n');
  List<String> inputPart2 =
      input.replaceAll(' ', '').replaceAll(':', ': ').split('\n');

  var times1 = parseLine(inputPart1[0]).toList();
  var distances1 = parseLine(inputPart1[1]).toList();

  var times2 = parseLine(inputPart2[0]).toList();
  var distances2 = parseLine(inputPart2[1]).toList();

  sw.stop();
  final parseTime = sw.elapsedMicroseconds;
  sw
    ..reset()
    ..start();

  final part1 = solve(times1, distances1);
  final part2 = solve(times2, distances2);

  sw.stop();
  final solveTime = sw.elapsedMicroseconds;

  print("Part 1: ${part1}");
  print("Part 2: ${part2}");
  print('');
  print('Time parse: ${parseTime} us');
  print('Time solve: ${solveTime} us');
  print('Time all:   ${parseTime + solveTime} us');
}

int solve(times, distances) {
  int product = 1;

  for (int i = 0; i < times.length; i++) {
    final t = times[i];
    final s = distances[i];

    // trivial
    double a = (t / 2);
    double b = 0.5 * sqrt(t * t - 4 * s);
    double y1 = a - b;
    double y2 = a + b;

    int dist = y2.floor() - y1.ceil() + 1;

    // range is not inclusive, adjust if needed.
    if (y1.ceil() - y1 == 0) {
      dist--;
    }
    if (y2 - y2.floor() == 0) {
      dist--;
    }

    product *= dist;
  }

  return product;
}

Iterable<int> parseLine(String line) {
  return line
      .split(' ')
      .skip(1)
      .where((e) => e != "")
      .map((e) => int.parse(e.trim()));
}
