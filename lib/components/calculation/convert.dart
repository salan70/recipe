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
  String toRoundedDouble(String num) {
    const baseNum = 100;
    return ((double.tryParse(num)! * baseNum).round() / baseNum).toString();
  }
}
