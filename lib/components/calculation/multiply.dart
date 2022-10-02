import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Multiply {
  final Convert _convert = Convert();
  final Check _check = Check();

  // product:積
  String calcProduct(int countInCart, String? amount) {
    if (amount == null) {
      return '';
    }
    final amountType = _check.checkType(amount);

    if (amountType == 'blank') {
      return '';
    }

    final product = _multiply(countInCart, amount);

    if (amountType == 'fractions') {
      return _formatFractions(product);
    }

    return _convert.toIntOrDouble(product);
  }

  double _multiply(int countInCart, String amount) {
    return countInCart * _convert.toDoubleFromSomeTypes(amount);
  }

  String _formatFractions(double product) {
    if (product % 1 == 0) {
      return _convert.toIntOrDouble(product);
    }
    if (product > 1) {
      return product.toMixedFraction().toString();
    }
    return product.toFraction().toString();
  }
}
