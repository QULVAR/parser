import 'dart:convert';

Map<String, List<Map<String, dynamic>>> readJsonControlData(String jsonString) {
  final Map<String, dynamic> jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

  final List<Map<String, dynamic>> clpList =
      (jsonMap['data']['getAllDiscountsByCustomer']['clp'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

  final Map<String, List<Map<String, dynamic>>> result = {};

  for (final entry in clpList) {
    final desc = entry['description'] as String;
    final customers = (entry['customers'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    result[desc] = customers;
  }
  return result;
}

Map<String, dynamic> readJsonStatistics(String jsonString) {
  final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  final Map<String, dynamic> transactions = jsonMap['data'] as Map<String, dynamic>;
  return transactions;
}