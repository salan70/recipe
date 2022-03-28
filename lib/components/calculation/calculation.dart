import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';

class Calculation {
  /// execute
  String executeMultiply(int countInCart, String? amount) {
    String totalAmount = '';
    String amountType = checkNumType(amount);

    switch (amountType) {
      case 'int':
        String num = castToInt(amount!);
        totalAmount = multiplyDouble(countInCart, num);
        break;
      case 'double':
        totalAmount = multiplyDouble(countInCart, amount!);
        break;
      case 'fraction':
        totalAmount = multiplyFraction(countInCart, amount!);
        break;
      case 'mixed fraction':
        totalAmount = multiplyMixedFraction(countInCart, amount!);
        break;
      default:
        totalAmount = '';
        break;
    }

    return totalAmount;
  }

  String executeAdd(String? previousAmount, String? addAmount) {
    String totalAmount = '';
    String previousAmountType = checkNumType(previousAmount);
    String addAmountType = checkNumType(addAmount);

    // totalAmount = ''
    if (previousAmountType == '' && addAmountType == '') {
      totalAmount = '';
    } else if (previousAmountType == '') {
      totalAmount = addAmount!;
    } else if (addAmountType == '') {
      totalAmount = previousAmount!;
    }
    // totalAmount = double
    else if (previousAmountType == 'double' || addAmountType == 'double') {
      if (previousAmountType == 'fraction' || addAmountType == 'fraction') {
        totalAmount = doubleAddFraction(previousAmount!, addAmount!);
      } else if (previousAmountType == 'mixed fraction' ||
          addAmountType == 'mixed fraction') {
        totalAmount = doubleAddMixedFraction(previousAmount!, addAmount!);
      } else {
        totalAmount = doubleAddDouble(previousAmount!, addAmount!);
      }
    }
    // totalAmount = mixed fraction
    else if (previousAmountType == 'mixed fraction' ||
        addAmountType == 'mixed fraction') {
      if (previousAmountType == 'fraction' || addAmountType == 'fraction') {
        totalAmount = fractionAddMixedFraction(previousAmount!, addAmount!);
      } else if (previousAmountType == 'int' || addAmountType == 'int') {
        totalAmount = intAddMixedFraction(previousAmount!, addAmount!);
      } else {
        totalAmount =
            mixedFractionAddMixedFraction(previousAmount!, addAmount!);
      }
    }
    // totalAmount = fraction
    else if (previousAmountType == 'fraction' || addAmountType == 'fraction') {
      if (previousAmountType == 'int' || addAmountType == 'int') {
        totalAmount = intAddFraction(previousAmount!, addAmount!);
      } else {
        totalAmount = fractionAddMixedFraction(previousAmount!, addAmount!);
      }
    }
    // totalAmount = int
    else if (previousAmountType == 'int' && addAmountType == 'int') {
      totalAmount = intAddInt(previousAmount!, addAmount!);
    }
    // totalAmount = '' ※ここに入ることはない想定
    else {
      print('関数「executeAdd」に欠陥あり');
      totalAmount = '';
    }

    return totalAmount;
  }

  /// check
  String checkNumType(String? num) {
    String amountType = '';

    if (num == null) {
      amountType = 'null';
    } else if (num == '') {
      amountType = 'blank';
    }
    // fraction or mixedFraction
    else if (num.contains('/')) {
      try {
        num.toFraction();
        if (num.toFraction().toDouble() >= 1) {
          amountType = 'castable fraction';
        } else {
          amountType = 'fraction';
        }
      } catch (e) {
        try {
          num.toMixedFraction();
          amountType = 'mixed fraction';
        } catch (e) {
          amountType = 'error';
        }
      }
    }
    // double or int
    else {
      try {
        String doubleNum = double.tryParse(num).toString();
        amountType = 'double';
        if (doubleNum.endsWith('.0')) {
          amountType = 'int';
        }
      } catch (e) {
        amountType = 'error';
      }
    }

    return amountType;
  }

  /// add
  String intAddInt(String originalNum, String addNum) {
    String totalAmount =
        (int.parse(originalNum) + int.parse(addNum)).toString();

    return totalAmount;
  }

  String intAddDouble(String originalNum, String addNum) {
    String totalAmount =
        (double.parse(originalNum) + double.parse(addNum)).toString();

    return totalAmount;
  }

  String intAddFraction(String originalNum, String addNum) {
    String totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      totalAmount = castToMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String intAddMixedFraction(String originalNum, String addNum) {
    String totalAmount =
        (originalNum.toMixedFraction() + addNum.toMixedFraction()).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    }

    return totalAmount;
  }

  String doubleAddDouble(String originalNum, String addNum) {
    String totalAmount =
        (double.parse(originalNum) + double.parse(addNum)).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    }

    return totalAmount;
  }

  String doubleAddFraction(String originalNum, String addNum) {
    String totalAmount =
        (originalNum.toFraction().toDouble() + addNum.toFraction().toDouble())
            .toString();

    if (totalAmount.endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    }
    return totalAmount;
  }

  String doubleAddMixedFraction(String originalNum, String addNum) {
    String totalAmount = (originalNum.toMixedFraction().toDouble() +
            addNum.toMixedFraction().toDouble())
        .toString();

    if (totalAmount.endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    }
    return totalAmount;
  }

  String fractionAddFraction(String originalNum, String addNum) {
    String totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      totalAmount = castToMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String fractionAddMixedFraction(String originalNum, String addNum) {
    String originalNumType = checkNumType(originalNum);

    String totalAmount = '';

    if (originalNumType == 'mixed fraction') {
      List<String> originalNumList = addNum.split(' ');
      String originalNumInt = originalNumList[0];
      String originalNumFraction = originalNumList[1];

      totalAmount = (addNum.toFraction() +
              originalNumInt.toFraction() +
              originalNumFraction.toFraction())
          .toString();
    } else {
      List<String> addNumList = addNum.split(' ');
      String addNumInt = addNumList[0];
      String addNumFraction = addNumList[1];

      totalAmount = (originalNum.toFraction() +
              addNumInt.toFraction() +
              addNumFraction.toFraction())
          .toString();
    }

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      totalAmount = castToMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String mixedFractionAddMixedFraction(String originalNum, String addNum) {
    String totalAmount =
        (originalNum.toMixedFraction() + addNum.toMixedFraction()).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    }

    return totalAmount;
  }

  /// multiply
  String multiplyInt(int countInCart, String num) {
    String totalAmount = (countInCart * int.parse(num)).toString();

    return totalAmount;
  }

  String multiplyDouble(int countInCart, String num) {
    String totalAmount = (countInCart * double.parse(num)).toString();

    if (totalAmount.toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    }

    return totalAmount;
  }

  String multiplyFraction(int countInCart, String num) {
    String totalAmount =
        (countInCart.toFraction() * num.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      totalAmount = castToMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String multiplyMixedFraction(int countInCart, String num) {
    String totalAmount =
        (countInCart.toMixedFraction() * num.toMixedFraction()).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = castToInt(totalAmount);
    }

    return totalAmount;
  }

  /// cast
  String castToMixedFraction(String num) {
    MixedFraction mixedFractionNum =
        MixedFraction.fromFraction(num.toFraction());

    return mixedFractionNum.toString();
  }

  String castToInt(String num) {
    int intNum = int.parse(num);

    return intNum.toString();
  }
}
