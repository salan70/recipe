import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Multiply {
  final Convert _convert = Convert();
  final Check _check = Check();

  String calcProduct(int countInCart, String? amount) {
    final amountType = _check.checkType(amount);

    switch (amountType) {
      case 'int':
        final resultOfDouble = _multiplyOfDouble(countInCart, amount!);
        return _convert.toIntFromDouble(resultOfDouble);
      case 'double':
        final resultOfDouble = _multiplyOfDouble(countInCart, amount!);
        return _convert.toIntFromDouble(resultOfDouble);
      case 'fraction':
        return _formatFractions(countInCart, amount!);
      case 'mixed fraction':
        return _formatFractions(countInCart, amount!);
      default:
        return '';
    }
  }

  double _multiplyOfDouble(int countInCart, String amount) {
    return countInCart * _convert.toDoubleFromSomeTypes(amount);
  }

  String _formatFractions(int countInCart, String amount) {
    final amountOfDouble = _multiplyOfDouble(countInCart, amount);

    if (amountOfDouble % 1 == 0) {
      return _convert.toIntFromDouble(amountOfDouble);
    }
    if (amountOfDouble > 1) {
      return amountOfDouble.toMixedFraction().toString();
    }

    return amountOfDouble.toFraction().toString();
  }
}
