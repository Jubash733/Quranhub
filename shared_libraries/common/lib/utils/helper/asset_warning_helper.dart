import 'package:common/utils/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:resources/extensions/context_extensions.dart';

class AssetWarningHelper {
  static final Set<String> _shownWarnings = <String>{};

  static bool isMissingAssetError(Object error) {
    return error.toString().contains('Unable to load asset');
  }

  static void reportMissingAsset(String assetPath) {
    _showWarning(
      key: 'missing:$assetPath',
      message: 'Missing asset: $assetPath',
    );
  }

  static void reportInvalidAsset(String assetPath) {
    _showWarning(
      key: 'invalid:$assetPath',
      message: 'Invalid asset payload: $assetPath',
    );
  }

  static void _showWarning({
    required String key,
    required String message,
  }) {
    if (_shownWarnings.contains(key)) {
      return;
    }
    _shownWarnings.add(key);
    debugPrint(message);
    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    context.showCustomFlashMessage(
      message: message,
      status: 'failed',
      positionBottom: true,
      darkTheme: isDark,
    );
  }
}
