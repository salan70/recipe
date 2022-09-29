import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/components/calculation/convert.dart';

void main() {
  final convert = Convert();

  group('toDouble', () {
    group('2 *', () {
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
  });
}
