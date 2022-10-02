import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Multiply {
  final Convert _convert = Convert();
  final Check _check = Check();

  String calcProduct(int countInCart, String? amount) {
    final amountType = _check.checkType(amount);

    if (amountType == 'blank' || amountType == 'null') {
      return '';
    }

    final resultOfDouble = _multiply(countInCart, amount!);

    if (amountType == 'int' || amountType == 'double') {
      return _convert.toIntOrDoubleFromDouble(resultOfDouble);
    }

    // fraction or mixed fraction
    return _formatFractions(countInCart, amount);
  }

  double _multiply(int countInCart, String amount) {
    return countInCart * _convert.toDoubleFromSomeTypes(amount);
  }

  String _formatFractions(int countInCart, String amount) {
    final amountOfDouble = _multiply(countInCart, amount);

    if (amountOfDouble % 1 == 0) {
      return _convert.toIntOrDoubleFromDouble(amountOfDouble);
    }
    if (amountOfDouble > 1) {
      return amountOfDouble.toMixedFraction().toString();
    }

    return amountOfDouble.toFraction().toString();
  }
}
