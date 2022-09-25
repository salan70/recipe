import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Multiply {
  final Convert _convert = Convert();
  final Check _check = Check();

  String executeMultiply(int countInCart, String? amount) {
    final amountType = _check.checkNumType(amount);

    switch (amountType) {
      case 'int':
        return _multiplyInt(countInCart, amount!);
      case 'double':
        return _multiplyDouble(countInCart, amount!);
      case 'fraction':
        return _multiplyFraction(countInCart, amount!);
      case 'mixed fraction':
        return _multiplyMixedFraction(countInCart, amount!);
      default:
        return '';
    }
  }

  /// multiply
  String _multiplyInt(int countInCart, String num) {
    return (countInCart * double.parse(num).toInt()).toString();
  }

  String _multiplyDouble(int countInCart, String num) {
    final totalAmount = (countInCart * double.parse(num)).toString();

    if (totalAmount.endsWith('.0')) {
      return _convert.toInt(totalAmount);
    }

    return totalAmount;
  }

  String _multiplyFraction(int countInCart, String num) {
    final totalAmount =
        (countInCart.toFraction() * num.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _convert.toInt(totalAmount.toFraction().toDouble().toString());
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      return _convert.toMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _multiplyMixedFraction(int countInCart, String num) {
    final totalAmount =
        (countInCart.toMixedFraction() * num.toMixedFraction()).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _convert
          .toInt(totalAmount.toMixedFraction().toDouble().toString());
    }
    return totalAmount;
  }
}
