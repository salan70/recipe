import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/components/calculation/calculation.dart';

void main() {
  final calculation = Calculation();

  group('executeMultiply', () {
    group('int + 〇〇', () {
      test('null', () {
        expect(calculation.executeMultiply(1, null), '');
      });
      test('', () {
        expect(calculation.executeMultiply(1, ''), '');
      });
      test('int', () {
        expect(calculation.executeMultiply(1, '1'), '1');
      });
      test('double', () {
        expect(calculation.executeMultiply(1, '1.5'), '1.5');
      });
      test('fraction 1', () {
        expect(calculation.executeMultiply(1, '1/2'), '1/2');
      });
      test('fraction 2', () {
        expect(calculation.executeMultiply(1, '2/2'), '1');
      });
      test('mixedFraction 1', () {
        expect(calculation.executeMultiply(1, '1 1/2'), '1 1/2');
      });
      test('mixedFraction 2', () {
        expect(calculation.executeMultiply(1, '1 2/2'), '2');
      });
    });
  });
}
