import 'package:fraction/fraction.dart';

class Check {
  //TODO 引数の型をString?からStringにできないか検討する
  String checkType(String amount) {
    if (amount == '') {
      return 'blank';
    }

    // fraction or mixedFraction
    if (amount.contains('/')) {
      return 'fractions';
    }

    // int or double
    if (int.tryParse(amount) != null) {
      return 'int';
    }
    return 'double';
  }
}
