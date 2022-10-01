import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Multiply {
  final Convert _convert = Convert();
  final Check _check = Check();

  String calculate(int countInCart, String? amount) {
    final amountType = _check.checkType(amount);

    switch (amountType) {
      case 'int':
        return _int(countInCart, amount!);
      case 'double':
        return _double(countInCart, amount!);
      case 'fraction':
        return _fraction(countInCart, amount!);
      case 'mixed fraction':
        return _mixedFraction(countInCart, amount!);
      default:
        return '';
    }
  }

  /// private
  String _int(int countInCart, String num) {
    return (countInCart * double.parse(num).toInt()).toString();
  }

  String _double(int countInCart, String num) {
    final totalAmount = (countInCart * double.parse(num)).toString();

    if (totalAmount.endsWith('.0')) {
      return _convert.toInt(totalAmount);
    }

    return totalAmount;
  }

  String _fraction(int countInCart, String num) {
    final totalAmount =
        (countInCart.toFraction() * num.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _convert.toInt(totalAmount.toFraction().toDouble().toString());
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      return _convert.toMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _mixedFraction(int countInCart, String num) {
    final totalAmount =
        (countInCart.toMixedFraction() * num.toMixedFraction()).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _convert
          .toInt(totalAmount.toMixedFraction().toDouble().toString());
    }
    return totalAmount;
  }
}
