import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/components/calculation/calculation.dart';

void main() {
  final calculation = Calculation();

  group('checkNumType test', () {
    test('null', () {
      expect(calculation._checkNumType(null), 'null');
    });
    test('', () {
      expect('', 'blank');
    });
    test('fraction', () {
      expect(1 / 2, 'fraction');
    });
  });
}
