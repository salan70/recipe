import 'package:fraction/fraction.dart';

class Calculation {
  /// execute
  String executeMultiply(int countInCart, String? amount) {
    final amountType = _checkNumType(amount);

    switch (amountType) {
      case 'int':
        return _multiplyInt(countInCart, _castToInt(amount!));
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

  String executeAdd(String? previousAmount, String? addAmount) {
    var totalAmount = '';
    final previousAmountType = _checkNumType(previousAmount);
    final addAmountType = _checkNumType(addAmount);

    // totalAmount = ''
    if (previousAmountType == 'blank' && addAmountType == 'blank') {
      totalAmount = '';
    } else if (previousAmountType == 'blank') {
      totalAmount = addAmount!;
    } else if (addAmountType == 'blank') {
      totalAmount = previousAmount!;
    }
    // totalAmount = double
    else if (previousAmountType == 'double' || addAmountType == 'double') {
      if (previousAmountType == 'fraction' || addAmountType == 'fraction') {
        totalAmount = _doubleAddFraction(previousAmount!, addAmount!);
      } else if (previousAmountType == 'mixed fraction' ||
          addAmountType == 'mixed fraction') {
        totalAmount = _doubleAddMixedFraction(previousAmount!, addAmount!);
      } else {
        // print('+++++++++++++');
        totalAmount = _doubleAddDouble(previousAmount!, addAmount!);
        // print('------');
      }
    }
    // totalAmount = mixed fraction
    else if (previousAmountType == 'mixed fraction' ||
        addAmountType == 'mixed fraction') {
      if (previousAmountType == 'fraction' || addAmountType == 'fraction') {
        // print('$previousAmount $addAmount');
        totalAmount = _fractionAddMixedFraction(previousAmount!, addAmount!);
      } else if (previousAmountType == 'int' || addAmountType == 'int') {
        totalAmount = _intAddMixedFraction(previousAmount!, addAmount!);
      } else {
        totalAmount =
            _mixedFractionAddMixedFraction(previousAmount!, addAmount!);
      }
    }
    // totalAmount = fraction
    else if (previousAmountType == 'fraction' || addAmountType == 'fraction') {
      if (previousAmountType == 'int' || addAmountType == 'int') {
        totalAmount = _intAddFraction(previousAmount!, addAmount!);
      } else {
        totalAmount = _fractionAddFraction(previousAmount!, addAmount!);
      }
    }
    // totalAmount = int
    else if (previousAmountType == 'int' && addAmountType == 'int') {
      totalAmount = _intAddInt(previousAmount!, addAmount!);
    }
    // totalAmount = '' ※ここに入ることはない想定
    else {
      totalAmount = '';
    }

    return totalAmount;
  }

  /// check
  String _checkNumType(String? num) {
    if (num == null) {
      return 'null';
    } else if (num == '') {
      return 'blank';
    }
    // fraction or mixedFraction
    else if (num.contains('/')) {
      try {
        num.toFraction();

        if (num.toFraction().toDouble() >= 1) {
          return 'castable fraction';
        } else {
          return 'fraction';
        }
      } on Exception {
        try {
          num.toMixedFraction();
          return 'mixed fraction';
        } on Exception {
          return 'error';
        }
      }
    }
    // double or int
    else {
      try {
        final doubleNum = double.tryParse(num).toString();
        if (doubleNum.endsWith('.0')) {
          return 'int';
        } else {
          return 'double';
        }
      } on Exception {
        return 'error';
      }
    }
  }

  /// add
  String _intAddInt(String originalNum, String addNum) {
    return (int.parse(originalNum) + int.parse(addNum)).toString();
  }

  String _intAddFraction(String originalNum, String addNum) {
    final totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(totalAmount);
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      return _castToMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _intAddMixedFraction(String originalNum, String addNum) {
    var totalAmount = '';

    final originalNumType = _checkNumType(originalNum);
    final addNumType = _checkNumType(addNum);

    if (originalNumType == 'int') {
      final originalNumInt = int.parse(originalNum);
      totalAmount =
          (originalNumInt.toMixedFraction() + addNum.toMixedFraction())
              .toString();

      if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
        totalAmount = _castToInt(totalAmount);
      }
    } else if (addNumType == 'int') {
      final addNumInt = int.parse(addNum);
      totalAmount =
          (originalNum.toMixedFraction() + addNumInt.toMixedFraction())
              .toString();

      if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
        return _castToInt(totalAmount);
      }
    }

    return totalAmount;
  }

  String _doubleAddDouble(String originalNum, String addNum) {
    final totalAmount =
        (double.parse(originalNum) + double.parse(addNum)).toString();

    if (totalAmount.endsWith('.0')) {
      return _castToInt(totalAmount);
    }

    return totalAmount;
  }

  String _doubleAddFraction(String originalNum, String addNum) {
    final originalNumType = _checkNumType(originalNum);
    var totalAmount = '';

    if (originalNumType == 'fraction') {
      totalAmount =
          (originalNum.toFraction().toDouble() + double.tryParse(addNum)!)
              .toString();
    } else {
      totalAmount =
          (double.tryParse(originalNum)! + addNum.toFraction().toDouble())
              .toString();
    }

    if (totalAmount.endsWith('.0')) {
      return _castToInt(totalAmount);
    } else {
      return _castToRoundedDouble(totalAmount);
    }
  }

  String _doubleAddMixedFraction(String originalNum, String addNum) {
    final originalNumType = _checkNumType(originalNum);
    var totalAmount = '';

    if (originalNumType == 'mixed fraction') {
      totalAmount =
          (originalNum.toMixedFraction().toDouble() + double.tryParse(addNum)!)
              .toString();
    } else {
      totalAmount =
          (double.tryParse(originalNum)! + addNum.toMixedFraction().toDouble())
              .toString();
    }

    if (totalAmount.endsWith('.0')) {
      return _castToInt(totalAmount);
    } else {
      return _castToRoundedDouble(totalAmount);
    }
  }

  String _fractionAddFraction(String originalNum, String addNum) {
    final totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(totalAmount);
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      return _castToMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _fractionAddMixedFraction(String originalNum, String addNum) {
    final originalNumType = _checkNumType(originalNum);

    var totalAmount = '';

    if (originalNumType == 'mixed fraction') {
      // 帯分数を整数と小数に分割
      final originalNumList = originalNum.split(' ');
      final originalNumInt = originalNumList[0];
      final originalNumFraction = originalNumList[1];

      totalAmount = (originalNumInt.toFraction() +
              originalNumFraction.toFraction() +
              addNum.toFraction())
          .toString();
    } else {
      // 帯分数を整数と小数に分割
      final addNumList = addNum.split(' ');
      final addNumInt = addNumList[0];
      final addNumFraction = addNumList[1];

      totalAmount = (originalNum.toFraction() +
              addNumInt.toFraction() +
              addNumFraction.toFraction())
          .toString();
    }

    totalAmount = _castToMixedFraction(totalAmount);

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(totalAmount);
    }

    return totalAmount;
  }

  String _mixedFractionAddMixedFraction(String originalNum, String addNum) {
    final totalAmount =
        (originalNum.toMixedFraction() + addNum.toMixedFraction()).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(totalAmount);
    }

    return totalAmount;
  }

  /// multiply
  String _multiplyInt(int countInCart, String num) {
    return (countInCart * int.parse(num)).toString();
  }

  String _multiplyDouble(int countInCart, String num) {
    final totalAmount = (countInCart * double.parse(num)).toString();

    if (totalAmount.endsWith('.0')) {
      return _castToInt(totalAmount);
    }

    return totalAmount;
  }

  String _multiplyFraction(int countInCart, String num) {
    final totalAmount =
        (countInCart.toFraction() * num.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(totalAmount.toFraction().toDouble().toString());
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      return _castToMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _multiplyMixedFraction(int countInCart, String num) {
    final totalAmount =
        (countInCart.toMixedFraction() * num.toMixedFraction()).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(totalAmount.toMixedFraction().toDouble().toString());
    }
    return totalAmount;
  }

  /// cast
  String _castToMixedFraction(String num) {
    return MixedFraction.fromFraction(num.toFraction()).toString();
  }

  String _castToInt(String num) {
    if (num.endsWith('.0')) {
      final pos = num.length - 2;
      return num.substring(0, pos);
    }

    return num;
  }

  // 四捨五入
  String _castToRoundedDouble(String num) {
    const baseNum = 100;
    return ((double.tryParse(num)! * baseNum).round() / baseNum).toString();
  }
}
