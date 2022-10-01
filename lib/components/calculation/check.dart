import 'package:fraction/fraction.dart';

class Check {
  //TODO 引数の型をString?からStringにできないか検討する
  String checkType(String? num) {
    if (num == null) {
      return 'null';
    } else if (num == '') {
      return 'blank';
    }
    // fraction or mixedFraction
    else if (num.contains('/')) {
      try {
        num.toFraction();
        return 'fraction';
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
        if (double.tryParse(num)! % 1 == 0) {
          return 'int';
        } else {
          return 'double';
        }
      } on Exception {
        return 'error';
      }
    }
  }
}
