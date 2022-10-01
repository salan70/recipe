import 'package:fraction/fraction.dart';

class Convert {
  String toMixedFraction(String num) {
    return MixedFraction.fromFraction(num.toFraction()).toString();
  }

  String toInt(String num) {
    if (num.endsWith('.0')) {
      return double.parse(num).toInt().toString();
    }

    return num;
  }

  /// TODO 関数名変える
  String toInt2(double num) {
    if (num % 1 == 0) {
      return num.toInt().toString();
    }
    return num.toString();
  }

  double toDouble(String num) {
    // Fraction or MixedFraction
    if (num.contains('/')) {
      try {
        return num.toFraction().toDouble();
      } on Exception {
        try {
          return num.toMixedFraction().toDouble();
        }
        // このExceptionには行かない想定
        on Exception {
          print('toMixedFraction()ができない');
          return 0;
        }
      }
    }
    // int or Double
    else {
      return double.tryParse(num)!;
    }
  }

  // 四捨五入
  double toRoundedDouble(double num) {
    const baseNum = 100;
    return (num * baseNum).round() / baseNum;
  }
}
