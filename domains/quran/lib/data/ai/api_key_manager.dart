import 'dart:math';

class ApiKeyManager {
  final Map<String, List<String>> _keys = {};
  final Map<String, int> _indices = {};

  void setKeys(String providerId, List<String> keys) {
    if (keys.isEmpty) return;
    _keys[providerId] = keys;
    _indices[providerId] = 0;
  }

  String? getNextKey(String providerId) {
    final keys = _keys[providerId];
    if (keys == null || keys.isEmpty) return null;

    final index = _indices[providerId] ?? 0;
    final key = keys[index];

    // Round-robin for next call
    _indices[providerId] = (index + 1) % keys.length;
    return key;
  }

  // Random rotation for spreading load
  String? getRandomKey(String providerId) {
    final keys = _keys[providerId];
    if (keys == null || keys.isEmpty) return null;
    return keys[Random().nextInt(keys.length)];
  }
}
