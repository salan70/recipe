import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/components/calculation/convert.dart';

void main() {
  final convert = Convert();

  group('toDouble', () {
    test('mixedFraction', () {
      expect(convert.toDoubleFromSomeTypes('1 1/2'), 1.5);
    });
    test('fraction', () {
      expect(convert.toDoubleFromSomeTypes('1/2'), 0.5);
    });
    test('double', () {
      expect(convert.toDoubleFromSomeTypes('0.5'), 0.5);
    });
    test('int', () {
      expect(convert.toDoubleFromSomeTypes('5'), 5.0);
    });
  });

  group('toInt', () {
    test('', () {
      expect(convert.toIntOrDouble(1.0), '1');
    });
    test('', () {
      expect(convert.toIntOrDouble(1.5), '1.5');
    });
  });

  group('toRoundedDouble', () {
    test('', () {
      expect(convert.toRoundedDouble(1.0), 1.0);
    });
    test('', () {
      expect(convert.toRoundedDouble(1.5), 1.5);
    });
    test('', () {
      expect(convert.toRoundedDouble(1.55), 1.55);
    });
    test('', () {
      expect(convert.toRoundedDouble(1.555), 1.56);
    });
    test('', () {
      expect(convert.toRoundedDouble(1.999), 2.0);
    });
  });
}
