import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:common/utils/helper/asset_warning_helper.dart';
import 'package:library_domain/data/models/library_catalog_item.dart';

class LibraryCatalogDataSource {
  Future<List<LibraryCatalogItem>> loadCatalog() async {
    const assetPath = 'assets/data/library_catalog.json';
    try {
      final raw = await rootBundle.loadString(assetPath);
      final payload = jsonDecode(raw);
      if (payload is! List) {
        AssetWarningHelper.reportInvalidAsset(assetPath);
        return [];
      }
      return payload
          .map((item) => LibraryCatalogItem.fromJson(item))
          .toList();
    } catch (e) {
      if (AssetWarningHelper.isMissingAssetError(e)) {
        AssetWarningHelper.reportMissingAsset(assetPath);
      } else {
        AssetWarningHelper.reportInvalidAsset(assetPath);
      }
      return [];
    }
  }
}
