import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/components/calculation/calculation.dart';

void main() {
  final calculation = Calculation();

  group('executeMultiply', () {
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

  group('executeAdd', () {
    group('(空) + 〇〇', () {
      test('(空)', () {
        expect(calculation.executeAdd('', ''), '');
      });
      test('int', () {
        expect(calculation.executeAdd('', '1'), '1');
      });
      test('double 1', () {
        expect(calculation.executeAdd('', '1.5'), '1.5');
      });
      test('double 2', () {
        expect(calculation.executeAdd('', '1.0'), '1.0');
      });
      test('fraction 1', () {
        expect(calculation.executeAdd('', '1/2'), '1/2');
      });
      test('mixedFraction 1', () {
        expect(calculation.executeAdd('', '1 1/2'), '1 1/2');
      });
    });
  });
}
