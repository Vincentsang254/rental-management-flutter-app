import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  /// Initialize storage (call this in main)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Ensure storage is ready
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception(
        "LocalStorageService not initialized. Call init() in main().",
      );
    }
    return _prefs!;
  }

  /// Save List of Objects (safe JSON encoding)
  static Future<void> saveList(String key, List<dynamic> data) async {
    try {
      final encoded = data.map((e) {
        if (e is Map) {
          return jsonEncode(e);
        } else {
          return jsonEncode(e.toJson());
        }
      }).toList();

      await _instance.setStringList(key, encoded);
    } catch (e) {
      // Fail silently but don't crash app
      print("Save error: $e");
    }
  }

  /// Load List of Objects (safe decoding)
  static List<Map<String, dynamic>> loadList(String key) {
    try {
      final data = _instance.getStringList(key);

      if (data == null) return [];

      return data.map((e) {
        final decoded = jsonDecode(e);
        return Map<String, dynamic>.from(decoded);
      }).toList();
    } catch (e) {
      print("Load error: $e");
      return [];
    }
  }

  /// Clear specific key
  static Future<void> clear(String key) async {
    await _instance.remove(key);
  }

  /// Clear all storage
  static Future<void> clearAll() async {
    await _instance.clear();
  }
}
