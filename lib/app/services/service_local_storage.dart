import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  /// Initialize storage (call this in main)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save List of Objects (as JSON)
  static Future<void> saveList(String key, List<dynamic> data) async {
    final encoded =
        data.map((e) => jsonEncode(e)).toList();
    await _prefs.setStringList(key, encoded);
  }

  /// Load List of Objects
  static List<Map<String, dynamic>> loadList(String key) {
    final data = _prefs.getStringList(key);
    if (data == null) return [];

    return data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  /// Clear specific key
  static Future<void> clear(String key) async {
    await _prefs.remove(key);
  }

  /// Clear all storage
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
