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

  String toIntFromDouble(double num) {
    if (num % 1 == 0) {
      return num.toInt().toString();
    }
    return num.toString();
  }

  double toDoubleFromSomeTypes(String num) {
    // Rational.tryParse(x)は、xが整数、分数、帯分数以外の場合nullを返す
    if (Rational.tryParse(num) != null) {
      return Rational.tryParse(num)!.toDouble();
    }
    return double.parse(num);
  }

  // 四捨五入
  double toRoundedDouble(double num) {
    const baseNum = 100;
    return (num * baseNum).round() / baseNum;
  }
}
