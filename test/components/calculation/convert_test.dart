import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/components/calculation/convert.dart';

void main() {
  final convert = Convert();

  group('toDouble', () {
    test('mixedFraction', () {
      expect(convert.toDouble('1 1/2'), 1.5);
    });
    test('fraction', () {
      expect(convert.toDouble('1/2'), 0.5);
    });
    test('double', () {
      expect(convert.toDouble('0.5'), 0.5);
    });
    test('int', () {
      expect(convert.toDouble('5'), 5.0);
    });
  });

  group('toRoundedDouble', () {
    test('', () {
      expect(convert.toRoundedDouble2(1.0), 1.0);
    });
    test('', () {
      expect(convert.toRoundedDouble2(1.5), 1.5);
    });
    test('', () {
      expect(convert.toRoundedDouble2(1.55), 1.55);
    });
    test('', () {
      expect(convert.toRoundedDouble2(1.555), 1.56);
    });
    test('', () {
      expect(convert.toRoundedDouble2(1.999), 2.0);
    });
  });
}
