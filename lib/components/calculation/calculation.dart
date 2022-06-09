import 'package:fraction/fraction.dart';

class Calculation {
  /// execute
  String executeMultiply(int countInCart, String? amount) {
    final String _amountType = _checkNumType(amount);

    switch (_amountType) {
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
    String _totalAmount = '';
    final String _previousAmountType = _checkNumType(previousAmount);
    final String _addAmountType = _checkNumType(addAmount);

    // totalAmount = ''
    if (_previousAmountType == 'blank' && _addAmountType == 'blank') {
      _totalAmount = '';
    } else if (_previousAmountType == 'blank') {
      _totalAmount = addAmount!;
    } else if (_addAmountType == 'blank') {
      _totalAmount = previousAmount!;
    }
    // totalAmount = double
    else if (_previousAmountType == 'double' || _addAmountType == 'double') {
      if (_previousAmountType == 'fraction' || _addAmountType == 'fraction') {
        _totalAmount = _doubleAddFraction(previousAmount!, addAmount!);
      } else if (_previousAmountType == 'mixed fraction' ||
          _addAmountType == 'mixed fraction') {
        _totalAmount = _doubleAddMixedFraction(previousAmount!, addAmount!);
      } else {
        // print('+++++++++++++');
        _totalAmount = _doubleAddDouble(previousAmount!, addAmount!);
        // print('------');
      }
    }
    // totalAmount = mixed fraction
    else if (_previousAmountType == 'mixed fraction' ||
        _addAmountType == 'mixed fraction') {
      if (_previousAmountType == 'fraction' || _addAmountType == 'fraction') {
        // print('$previousAmount $addAmount');
        _totalAmount = _fractionAddMixedFraction(previousAmount!, addAmount!);
      } else if (_previousAmountType == 'int' || _addAmountType == 'int') {
        _totalAmount = _intAddMixedFraction(previousAmount!, addAmount!);
      } else {
        _totalAmount =
            _mixedFractionAddMixedFraction(previousAmount!, addAmount!);
      }
    }
    // totalAmount = fraction
    else if (_previousAmountType == 'fraction' ||
        _addAmountType == 'fraction') {
      if (_previousAmountType == 'int' || _addAmountType == 'int') {
        _totalAmount = _intAddFraction(previousAmount!, addAmount!);
      } else {
        _totalAmount = _fractionAddFraction(previousAmount!, addAmount!);
      }
    }
    // totalAmount = int
    else if (_previousAmountType == 'int' && _addAmountType == 'int') {
      _totalAmount = _intAddInt(previousAmount!, addAmount!);
    }
    // totalAmount = '' ※ここに入ることはない想定
    else {
      print('関数「executeAdd」に欠陥あり');
      _totalAmount = '';
    }

    return _totalAmount;
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
      } catch (e) {
        try {
          num.toMixedFraction();
          return 'mixed fraction';
        } catch (e) {
          return 'error';
        }
      }
    }
    // double or int
    else {
      try {
        final String _doubleNum = double.tryParse(num).toString();
        if (_doubleNum.endsWith('.0')) {
          return 'int';
        } else {
          return 'double';
        }
      } catch (e) {
        return 'error';
      }
    }
  }

  /// add
  String _intAddInt(String originalNum, String addNum) {
    return (int.parse(originalNum) + int.parse(addNum)).toString();
  }

  String _intAddFraction(String originalNum, String addNum) {
    final String _totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();

    if (_totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(_totalAmount);
    } else if (_totalAmount.toFraction().toDouble() >= 1) {
      return _castToMixedFraction(_totalAmount);
    }

    return _totalAmount;
  }

  String _intAddMixedFraction(String originalNum, String addNum) {
    String _totalAmount = '';

    final String _originalNumType = _checkNumType(originalNum);
    final String _addNumType = _checkNumType(addNum);

    if (_originalNumType == 'int') {
      final int _originalNumInt = int.parse(originalNum);
      _totalAmount =
          (_originalNumInt.toMixedFraction() + addNum.toMixedFraction())
              .toString();

      if (_totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
        _totalAmount = _castToInt(_totalAmount);
      }
    } else if (_addNumType == 'int') {
      final int _addNumInt = int.parse(addNum);
      _totalAmount =
          (originalNum.toMixedFraction() + _addNumInt.toMixedFraction())
              .toString();

      if (_totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
        return _castToInt(_totalAmount);
      }
    }

    return _totalAmount;
  }

  String _doubleAddDouble(String originalNum, String addNum) {
    print('$originalNum $addNum');
    final String _totalAmount =
        (double.parse(originalNum) + double.parse(addNum)).toString();

    if (_totalAmount.endsWith('.0')) {
      return _castToInt(_totalAmount);
    }

    return _totalAmount;
  }

  String _doubleAddFraction(String originalNum, String addNum) {
    final String _originalNumType = _checkNumType(originalNum);
    String _totalAmount = '';

    if (_originalNumType == 'fraction') {
      _totalAmount =
          (originalNum.toFraction().toDouble() + double.tryParse(addNum)!)
              .toString();
    } else {
      _totalAmount =
          (double.tryParse(originalNum)! + addNum.toFraction().toDouble())
              .toString();
    }

    if (_totalAmount.endsWith('.0')) {
      return _castToInt(_totalAmount);
    } else {
      return _castToRoundedDouble(_totalAmount);
    }
  }

  String _doubleAddMixedFraction(String originalNum, String addNum) {
    final String _originalNumType = _checkNumType(originalNum);
    String _totalAmount = '';

    if (_originalNumType == 'mixed fraction') {
      _totalAmount =
          (originalNum.toMixedFraction().toDouble() + double.tryParse(addNum)!)
              .toString();
    } else {
      _totalAmount =
          (double.tryParse(originalNum)! + addNum.toMixedFraction().toDouble())
              .toString();
    }

    if (_totalAmount.endsWith('.0')) {
      return _castToInt(_totalAmount);
    } else {
      return _castToRoundedDouble(_totalAmount);
    }
  }

  String _fractionAddFraction(String originalNum, String addNum) {
    final String _totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();

    if (_totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(_totalAmount);
    } else if (_totalAmount.toFraction().toDouble() >= 1) {
      return _castToMixedFraction(_totalAmount);
    }

    return _totalAmount;
  }

  String _fractionAddMixedFraction(String originalNum, String addNum) {
    final String _originalNumType = _checkNumType(originalNum);

    String _totalAmount = '';

    if (_originalNumType == 'mixed fraction') {
      List<String> originalNumList = originalNum.split(' ');
      final String _originalNumInt = originalNumList[0];
      final String _originalNumFraction = originalNumList[1];

      _totalAmount = (_originalNumInt.toFraction() +
              _originalNumFraction.toFraction() +
              addNum.toFraction())
          .toString();
    } else {
      List<String> addNumList = addNum.split(' ');
      final String _addNumInt = addNumList[0];
      final String _addNumFraction = addNumList[1];

      _totalAmount = (originalNum.toFraction() +
              _addNumInt.toFraction() +
              _addNumFraction.toFraction())
          .toString();
    }

    _totalAmount = _castToMixedFraction(_totalAmount);

    if (_totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(_totalAmount);
    }

    return _totalAmount;
  }

  String _mixedFractionAddMixedFraction(String originalNum, String addNum) {
    final String _totalAmount =
        (originalNum.toMixedFraction() + addNum.toMixedFraction()).toString();

    if (_totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(_totalAmount);
    }

    return _totalAmount;
  }

  /// multiply
  String _multiplyInt(int countInCart, String num) {
    return (countInCart * int.parse(num)).toString();
  }

  String _multiplyDouble(int countInCart, String num) {
    final String _totalAmount = (countInCart * double.parse(num)).toString();

    if (_totalAmount.toString().endsWith('.0')) {
      return _castToInt(_totalAmount);
    }

    return _totalAmount;
  }

  String _multiplyFraction(int countInCart, String num) {
    final String _totalAmount =
        (countInCart.toFraction() * num.toFraction()).toString();

    if (_totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(_totalAmount.toFraction().toDouble().toString());
    } else if (_totalAmount.toFraction().toDouble() >= 1) {
      return _castToMixedFraction(_totalAmount);
    }

    return _totalAmount;
  }

  String _multiplyMixedFraction(int countInCart, String num) {
    final String _totalAmount =
        (countInCart.toMixedFraction() * num.toMixedFraction()).toString();

    if (_totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _castToInt(_totalAmount.toMixedFraction().toDouble().toString());
    }
    return _totalAmount;
  }

  /// cast
  String _castToMixedFraction(String num) {
    return MixedFraction.fromFraction(num.toFraction()).toString();
  }

  String _castToInt(String num) {
    if (num.endsWith('.0')) {
      final _pos = num.length - 2;
      return num.substring(0, _pos);
    }

    return num;
  }

  // 四捨五入
  String _castToRoundedDouble(String num) {
    final _baseNum = 100;
    return ((double.tryParse(num)! * _baseNum).round() / _baseNum).toString();
  }
}
