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

  // 四捨五入
  String toRoundedDouble(String num) {
    const baseNum = 100;
    return ((double.tryParse(num)! * baseNum).round() / baseNum).toString();
  }
}
