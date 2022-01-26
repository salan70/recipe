class Validation {
  Validation();

  String? errorText(String? text) {
    // textが「null」「double型に変換可能」「""(値なし)」の場合、nullを返す
    if (text == null || double.tryParse(text) != null || text == "") {
      return null;
    } else if (text.contains("/")) {
      // 下記正規表現の意味：『半角数字と/(スラッシュ)以外を含む』
      if (RegExp(r"(?=^(?=.*[^0-9\/]).*$)").hasMatch(text)) {
        return "nooo";
        // 下記正規表現の意味：『「/(スラッシュ)」を2つ以上含む』
      } else if (RegExp(r".*\/.*\/.*").hasMatch(text)) {
        return "noo";
        // 下記正規表現の意味：『「0」から始まる or 「/0」を含む』
      } else if (RegExp(r"(^0.*)|(^(?=.*\/0).*$)").hasMatch(text)) {
        return "no";
      } else {
        return null;
      }
    } else {
      return "適切な値を入力してください";
    }
  }
}
