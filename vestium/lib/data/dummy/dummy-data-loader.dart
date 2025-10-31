import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DummyDataLoader {
  static Future<Map<String, dynamic>> loadDummyData() async {
    final String response = await rootBundle.loadString('assets/data/dummy_data.json');
    print('dummy data');
    return json.decode(response);
  }
}
