import 'package:intl/intl.dart';

String numbersFormat(double value) {
  final f = NumberFormat.currency(
    locale: 'ru_RU',
    symbol: '',
    decimalDigits: 1,
  );
  String result = f.format(value).trim();
  if (result.endsWith(',0')) {
    result = result.substring(0, result.length - 2);
  }
  return result;
}

String phoneFormat(String number) {
    return '+${number[0]}'
    ' (${number.substring(1,4)})'
    ' ${number.substring(4,7)}-'
    '${number.substring(7,9)}-'
    '${number.substring(9)}';
  }