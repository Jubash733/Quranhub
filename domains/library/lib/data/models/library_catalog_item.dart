import 'package:library_domain/domain/entities/library_category.dart';

class LibraryCatalogItem {
  LibraryCatalogItem({
    required this.itemId,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
    required this.sizeBytes,
    required this.source,
    required this.downloadUrl,
    required this.isBundled,
  });

  final String itemId;
  final String title;
  final String author;
  final String description;
  final LibraryCategory category;
  final int sizeBytes;
  final String source;
  final String? downloadUrl;
  final bool isBundled;

  factory LibraryCatalogItem.fromJson(Map<String, dynamic> json) {
    return LibraryCatalogItem(
      itemId: json['itemId'] as String,
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: libraryCategoryFromKey(json['category'] as String?) ??
          LibraryCategory.translation,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      source: json['source'] as String? ?? '',
      downloadUrl: json['downloadUrl'] as String?,
      isBundled: json['isBundled'] as bool? ?? false,
    );
  }
}
