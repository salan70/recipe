import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Add {
  final Convert _convert = Convert();
  final Check _check = Check();

  //TODO 引数の型をString?じゃなくてStringにできないか検討する
  String calcSum(String? amountA, String? amountB) {
    if (amountA == null || amountB == null) {
      return '';
    }

    final amountAType = _check.checkType(amountA);
    final amountBType = _check.checkType(amountB);
    final amountTypeList = [amountAType, amountBType];

    if (amountTypeList.contains('blank')) {
      return amountA + amountB;
    }

    final sum = _add(amountA, amountB);

    if (amountTypeList.contains('double')) {
      return _formatDouble(sum);
    }

    if (amountTypeList.contains('fractions')) {
      return _formatFractions(sum);
    }

    return _formatInt(sum);
  }

  double _add(String amountA, String amountB) {
    return _convert.toDoubleFromSomeTypes(amountA) +
        _convert.toDoubleFromSomeTypes(amountB);
  }

  String _formatInt(double amount) {
    return amount.toInt().toString();
  }

  String _formatDouble(double amount) {
    final amountOfRoundedDouble = _convert.toRoundedDouble(amount);
    return _convert.toIntOrDouble(amountOfRoundedDouble);
  }

  String _formatFractions(double amount) {
    if (amount % 1 == 0) {
      return _convert.toIntOrDouble(amount);
    }
    if (amount > 1) {
      return amount.toMixedFraction().toString();
    }
    return amount.toFraction().toString();
  }
}
