import 'package:flutter_test/flutter_test.dart';
import 'package:recipe/components/calculation/add.dart';
import 'package:recipe/components/calculation/multiply.dart';

void main() {
  final multiply = Multiply();
  final add = Add();

  group('executeMultiply', () {
    // 1 *
    group('1 *', () {
      test('null', () {
        expect(multiply.calcProduct(1, null), '');
      });
      test('', () {
        expect(multiply.calcProduct(1, ''), '');
      });
      test('int', () {
        expect(multiply.calcProduct(1, '1'), '1');
      });
      test('double 1', () {
        expect(multiply.calcProduct(1, '1.5'), '1.5');
      });
      test('double 2', () {
        expect(multiply.calcProduct(1, '1.0'), '1');
      });
      test('fraction 1', () {
        expect(multiply.calcProduct(1, '1/2'), '1/2');
      });
      test('fraction 2', () {
        expect(multiply.calcProduct(1, '2/2'), '1');
      });
      test('fraction 3', () {
        expect(multiply.calcProduct(1, '3/2'), '1 1/2');
      });
      test('mixedFraction 1', () {
        expect(multiply.calcProduct(1, '1 1/2'), '1 1/2');
      });
      test('mixedFraction 2', () {
        expect(multiply.calcProduct(1, '1 2/2'), '2');
      });
      test('mixedFraction 3', () {
        expect(multiply.calcProduct(1, '1 3/2'), '2 1/2');
      });
    });
    // 2 *
    group('2 *', () {
      test('null', () {
        expect(multiply.calcProduct(2, null), '');
      });
      test('', () {
        expect(multiply.calcProduct(2, ''), '');
      });
      test('int', () {
        expect(multiply.calcProduct(2, '1'), '2');
      });
      test('double', () {
        expect(multiply.calcProduct(2, '1.5'), '3');
      });
      test('double 1', () {
        expect(multiply.calcProduct(2, '1.0'), '2');
      });
      test('fraction 1', () {
        expect(multiply.calcProduct(2, '1/2'), '1');
      });
      test('fraction 2', () {
        expect(multiply.calcProduct(2, '2/2'), '2');
      });
      test('fraction 3', () {
        expect(multiply.calcProduct(2, '3/2'), '3');
      });
      test('mixedFraction 1', () {
        expect(multiply.calcProduct(2, '1 1/2'), '3');
      });
      test('mixedFraction 2', () {
        expect(multiply.calcProduct(2, '1 2/2'), '4');
      });
      test('mixedFraction 3', () {
        expect(multiply.calcProduct(2, '1 3/2'), '5');
      });
    });
  });

  group('executeAdd', () {
    // '' +
    group('(空) + 〇〇', () {
      test('(空)', () {
        expect(add.calcSum('', ''), '');
      });
      test('int', () {
        expect(add.calcSum('', '1'), '1');
      });
      test('double', () {
        expect(add.calcSum('', '1.5'), '1.5');
      });
      test('fraction', () {
        expect(add.calcSum('', '1/2'), '1/2');
      });
      test('mixedFraction', () {
        expect(add.calcSum('', '1 1/2'), '1 1/2');
      });
    });
    // double +
    group('double + 〇〇', () {
      test('(空)', () {
        expect(add.calcSum('1.5', ''), '1.5');
      });
      test('int', () {
        expect(add.calcSum('1.5', '1'), '2.5');
      });
      test('double 1', () {
        expect(add.calcSum('1.5', '1.5'), '3');
      });
      test('double 2', () {
        expect(add.calcSum('1.5', '1.6'), '3.1');
      });
      test('double 3', () {
        expect(add.calcSum('1.555', '1.444'), '3');
      });
      test('fraction 1', () {
        expect(add.calcSum('1.5', '1/2'), '2');
      });
      test('fraction 2', () {
        expect(add.calcSum('1.5', '1/5'), '1.7');
      });
      test('fraction 3', () {
        expect(add.calcSum('1.1', '1/3'), '1.43');
      });
      test('mixedFraction 1', () {
        expect(add.calcSum('1.5', '1 1/2'), '3');
      });
      test('mixedFraction 2', () {
        expect(add.calcSum('1.5', '1 1/5'), '2.7');
      });
      test('mixedFraction 3', () {
        expect(add.calcSum('1.1', '1 1/6'), '2.27');
      });
    });
    // fraction +
    group('fraction + 〇〇', () {
      test('(空)', () {
        expect(add.calcSum('1/2', ''), '1/2');
      });
      test('int', () {
        expect(add.calcSum('1/2', '1'), '1 1/2');
      });
      test('double', () {
        expect(add.calcSum('1/2', '1.5'), '2');
      });
      test('double', () {
        expect(add.calcSum('1/2', '1.6'), '2.1');
      });
      test('fraction 1', () {
        expect(add.calcSum('1/2', '1/2'), '1');
      });
      test('fraction 2', () {
        expect(add.calcSum('1/2', '1/5'), '7/10');
      });
      test('fraction 3 帯分数になる', () {
        expect(add.calcSum('1/2', '3/4'), '1 1/4');
      });
      test('fraction 4 約分される', () {
        expect(add.calcSum('2/8', '1/4'), '1/2');
      });
      test('mixedFraction 1', () {
        expect(add.calcSum('1/2', '1 1/2'), '2');
      });
      test('mixedFraction 2', () {
        expect(add.calcSum('1/2', '1 1/5'), '1 7/10');
      });
      test('mixedFraction 3', () {
        expect(add.calcSum('1/3', '1 1/3'), '1 2/3');
      });
      test('mixedFraction 4', () {
        expect(add.calcSum('1/3', '1 1/2'), '1 5/6');
      });
      test('mixedFraction 5 約分される', () {
        expect(add.calcSum('2/8', '1 1/4'), '1 1/2');
      });
    });
    // mixedFraction +
    group('double + 〇〇', () {
      test('(空)', () {
        expect(add.calcSum('1 1/2', ''), '1 1/2');
      });
      test('int', () {
        expect(add.calcSum('1 1/2', '1'), '2 1/2');
      });
      test('double', () {
        expect(add.calcSum('1 1/2', '1.5'), '3');
      });
      test('double', () {
        expect(add.calcSum('1 1/2', '1.6'), '3.1');
      });
      test('fraction 1', () {
        expect(add.calcSum('1 1/2', '1/2'), '2');
      });
      test('fraction 2', () {
        expect(add.calcSum('1 1/2', '1/5'), '1 7/10');
      });
      test('fraction 3 帯分数になる', () {
        expect(add.calcSum('1 1/2', '3/4'), '2 1/4');
      });
      test('fraction 4 約分される', () {
        expect(add.calcSum('1 2/8', '1/4'), '1 1/2');
      });
      test('mixedFraction 1', () {
        expect(add.calcSum('1 1/2', '1 1/2'), '3');
      });
      test('mixedFraction 2', () {
        expect(add.calcSum('1 1/2', '1 1/5'), '2 7/10');
      });
      test('mixedFraction 3 約分される', () {
        expect(add.calcSum('1 2/8', '1 1/4'), '2 1/2');
      });
    });
    // int +
    group('int + 〇〇', () {
      test('(空)', () {
        expect(add.calcSum('1', ''), '1');
      });
      test('int', () {
        expect(add.calcSum('1', '1'), '2');
      });
      test('double', () {
        expect(add.calcSum('1', '1.5'), '2.5');
      });
      test('double', () {
        expect(add.calcSum('1', '1.6'), '2.6');
      });
      test('fraction', () {
        expect(add.calcSum('1', '1/2'), '1 1/2');
      });
      test('mixedFraction', () {
        expect(add.calcSum('1', '1 1/2'), '2 1/2');
      });
    });
  });
}
