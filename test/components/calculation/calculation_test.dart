import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/components/calculation/calculation.dart';

void main() {
  final calculation = Calculation();

  group('executeMultiply', () {
    // 1 *
    group('1 *', () {
      test('null', () {
        expect(calculation.executeMultiply(1, null), '');
      });
      test('', () {
        expect(calculation.executeMultiply(1, ''), '');
      });
      test('int', () {
        expect(calculation.executeMultiply(1, '1'), '1');
      });
      test('double 1', () {
        expect(calculation.executeMultiply(1, '1.5'), '1.5');
      });
      test('double 2', () {
        expect(calculation.executeMultiply(1, '1.0'), '1');
      });
      test('fraction 1', () {
        expect(calculation.executeMultiply(1, '1/2'), '1/2');
      });
      test('fraction 2', () {
        expect(calculation.executeMultiply(1, '2/2'), '1');
      });
      test('fraction 3', () {
        expect(calculation.executeMultiply(1, '3/2'), '1 1/2');
      });
      test('mixedFraction 1', () {
        expect(calculation.executeMultiply(1, '1 1/2'), '1 1/2');
      });
      test('mixedFraction 2', () {
        expect(calculation.executeMultiply(1, '1 2/2'), '2');
      });
      test('mixedFraction 3', () {
        expect(calculation.executeMultiply(1, '1 3/2'), '2 1/2');
      });
    });
    // 2 *
    group('2 *', () {
      test('null', () {
        expect(calculation.executeMultiply(2, null), '');
      });
      test('', () {
        expect(calculation.executeMultiply(2, ''), '');
      });
      test('int', () {
        expect(calculation.executeMultiply(2, '1'), '2');
      });
      test('double', () {
        expect(calculation.executeMultiply(2, '1.5'), '3');
      });
      test('double 1', () {
        expect(calculation.executeMultiply(2, '1.0'), '2');
      });
      test('fraction 1', () {
        expect(calculation.executeMultiply(2, '1/2'), '1');
      });
      test('fraction 2', () {
        expect(calculation.executeMultiply(2, '2/2'), '2');
      });
      test('fraction 3', () {
        expect(calculation.executeMultiply(2, '3/2'), '3');
      });
      test('mixedFraction 1', () {
        expect(calculation.executeMultiply(2, '1 1/2'), '3');
      });
      test('mixedFraction 2', () {
        expect(calculation.executeMultiply(2, '1 2/2'), '4');
      });
      test('mixedFraction 3', () {
        expect(calculation.executeMultiply(2, '1 3/2'), '5');
      });
    });
  });

  group('executeAdd', () {
    // '' +
    group('(???) + ??????', () {
      test('(???)', () {
        expect(calculation.executeAdd('', ''), '');
      });
      test('int', () {
        expect(calculation.executeAdd('', '1'), '1');
      });
      test('double', () {
        expect(calculation.executeAdd('', '1.5'), '1.5');
      });
      test('fraction', () {
        expect(calculation.executeAdd('', '1/2'), '1/2');
      });
      test('mixedFraction', () {
        expect(calculation.executeAdd('', '1 1/2'), '1 1/2');
      });
    });
    // double +
    group('double + ??????', () {
      test('(???)', () {
        expect(calculation.executeAdd('1.5', ''), '1.5');
      });
      test('int', () {
        expect(calculation.executeAdd('1.5', '1'), '2.5');
      });
      test('double', () {
        expect(calculation.executeAdd('1.5', '1.5'), '3');
      });
      test('double', () {
        expect(calculation.executeAdd('1.5', '1.6'), '3.1');
      });
      test('fraction 1', () {
        expect(calculation.executeAdd('1.5', '1/2'), '2');
      });
      test('fraction 2', () {
        expect(calculation.executeAdd('1.5', '1/5'), '1.7');
      });
      test('fraction 3', () {
        expect(calculation.executeAdd('1.1', '1/3'), '1.43');
      });
      test('mixedFraction 1', () {
        expect(calculation.executeAdd('1.5', '1 1/2'), '3');
      });
      test('mixedFraction 2', () {
        expect(calculation.executeAdd('1.5', '1 1/5'), '2.7');
      });
      test('mixedFraction 3', () {
        expect(calculation.executeAdd('1.1', '1 1/6'), '2.27');
      });
    });
    // fraction +
    group('fraction + ??????', () {
      test('(???)', () {
        expect(calculation.executeAdd('1/2', ''), '1/2');
      });
      test('int', () {
        expect(calculation.executeAdd('1/2', '1'), '1 1/2');
      });
      test('double', () {
        expect(calculation.executeAdd('1/2', '1.5'), '2');
      });
      test('double', () {
        expect(calculation.executeAdd('1/2', '1.6'), '2.1');
      });
      test('fraction 1', () {
        expect(calculation.executeAdd('1/2', '1/2'), '1');
      });
      test('fraction 2', () {
        expect(calculation.executeAdd('1/2', '1/5'), '7/10');
      });
      test('fraction 3 ??????????????????', () {
        expect(calculation.executeAdd('1/2', '3/4'), '1 1/4');
      });
      test('fraction 4 ???????????????', () {
        expect(calculation.executeAdd('2/8', '1/4'), '1/2');
      });
      test('mixedFraction 1', () {
        expect(calculation.executeAdd('1/2', '1 1/2'), '2');
      });
      test('mixedFraction 2', () {
        expect(calculation.executeAdd('1/2', '1 1/5'), '1 7/10');
      });
      test('mixedFraction 3 ???????????????', () {
        expect(calculation.executeAdd('2/8', '1 1/4'), '1 1/2');
      });
    });
    // mixedFraction +
    group('double + ??????', () {
      test('(???)', () {
        expect(calculation.executeAdd('1 1/2', ''), '1 1/2');
      });
      test('int', () {
        expect(calculation.executeAdd('1 1/2', '1'), '2 1/2');
      });
      test('double', () {
        expect(calculation.executeAdd('1 1/2', '1.5'), '3');
      });
      test('double', () {
        expect(calculation.executeAdd('1 1/2', '1.6'), '3.1');
      });
      test('fraction 1', () {
        expect(calculation.executeAdd('1 1/2', '1/2'), '2');
      });
      test('fraction 2', () {
        expect(calculation.executeAdd('1 1/2', '1/5'), '1 7/10');
      });
      test('fraction 3 ??????????????????', () {
        expect(calculation.executeAdd('1 1/2', '3/4'), '2 1/4');
      });
      test('fraction 4 ???????????????', () {
        expect(calculation.executeAdd('1 2/8', '1/4'), '1 1/2');
      });
      test('mixedFraction 1', () {
        expect(calculation.executeAdd('1 1/2', '1 1/2'), '3');
      });
      test('mixedFraction 2', () {
        expect(calculation.executeAdd('1 1/2', '1 1/5'), '2 7/10');
      });
      test('mixedFraction 3 ???????????????', () {
        expect(calculation.executeAdd('1 2/8', '1 1/4'), '2 1/2');
      });
    });
    // int +
    group('int + ??????', () {
      test('(???)', () {
        expect(calculation.executeAdd('1', ''), '1');
      });
      test('int', () {
        expect(calculation.executeAdd('1', '1'), '2');
      });
      test('double', () {
        expect(calculation.executeAdd('1', '1.5'), '2.5');
      });
      test('double', () {
        expect(calculation.executeAdd('1', '1.6'), '2.6');
      });
      test('fraction', () {
        expect(calculation.executeAdd('1', '1/2'), '1 1/2');
      });
      test('mixedFraction', () {
        expect(calculation.executeAdd('1', '1 1/2'), '2 1/2');
      });
    });
  });
}
