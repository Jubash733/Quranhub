import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:library_domain/data/models/library_catalog_item.dart';

class LibraryCatalogDataSource {
  Future<List<LibraryCatalogItem>> loadCatalog() async {
    final raw = await rootBundle.loadString('assets/data/library_catalog.json');
    final payload = jsonDecode(raw) as List<dynamic>;
    return payload
        .map((item) => LibraryCatalogItem.fromJson(item))
        .toList();
  }
}
