import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DummyDataLoader {
  static Future<List<dynamic>> loadDummyData() async {
    final String response =
        await rootBundle.loadString('./dummy_data.json');
    return json.decode(response);
  }
}
