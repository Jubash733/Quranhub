import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'content_registry.dart';

class ComplianceValidator {
  static void validateUrl(String url) {
    if (!ContentRegistry.isUrlAllowed(url)) {
      final message = 'COMPLIANCE VIOLATION: URL not in allowed list: $url';
      if (kDebugMode) {
        log(message, name: 'ComplianceValidator', level: 1000); // Severe
        // In strict mode, we might throw exception
      }
    }
  }

  static void validateAsset(String assetPath) {
    // Basic check if asset path starts with allowed prefixes
    final isAllowed = ContentRegistry.allowedAssetSources.any(
      (prefix) => assetPath.startsWith(prefix),
    );
    if (!isAllowed) {
      log(
        'COMPLIANCE WARNING: Asset source may be unverified: $assetPath',
        name: 'ComplianceValidator',
      );
    }
  }
}
