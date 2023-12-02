import 'dart:io';
import 'dart:math';

const test = '''Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green ''';

const maxRed = 12;
const maxGreen = 13;
const maxBlue = 14;

void main() {
  var input = test;
  input = new File('input_2.txt').readAsStringSync();

  var games = input
      .split('\n')
      .map((e) => e.split(': ')[1].split(';'))
      .map((e) => e.map((t) => t.split(',').map((d) => d.trim().split(' '))));

  print('Result Part 1: ${part1(games)}');
  print('Result Part 2: ${part2(games)}');
}

int part1(Iterable games) {
  int sum = 0;
  for (final (index, game) in games.indexed) {
    if (isPossible(game)) {
      sum += index + 1;
    }
  }
  return sum;
}

int part2(Iterable games) {
  int sum = 0;

  for (final (index, game) in games.indexed) {
    int maxRed = 0;
    int maxGreen = 0;
    int maxBlue = 0;

    for (final round in game) {
      for (final x in round) {
        final color = x[1];
        final count = int.parse(x[0]);
        if (color == 'red') maxRed = max(maxRed, count);
        if (color == 'green') maxGreen = max(maxGreen, count);
        if (color == 'blue') maxBlue = max(maxBlue, count);
      }
    }

    sum += maxRed * maxGreen * maxBlue;
  }

  return sum;
}

bool isPossible(game) {
  for (final round in game) {
    for (final x in round) {
      final color = x[1];
      final count = int.parse(x[0]);
      if (color == 'red' && count > maxRed) return false;
      if (color == 'green' && count > maxGreen) return false;
      if (color == 'blue' && count > maxBlue) return false;
    }
  }
  return true;
}
