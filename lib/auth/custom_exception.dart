// カスタム例外
class CustomException implements Exception {
  final String? message;

  const CustomException({this.message = 'Auth Error!'});

  @override
  String toString() => 'CustomException { message: $message}';
}
