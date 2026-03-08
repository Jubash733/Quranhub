import 'package:dependencies/isar/isar.dart';
import 'package:library_domain/domain/entities/library_category.dart';
import 'package:library_domain/domain/entities/library_download_status.dart';
import 'package:library_domain/domain/entities/library_item_entity.dart';

part 'library_item_model.g.dart';

@collection
class LibraryItemModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String itemId;

  late String title;
  late String author;
  late String description;
  late String categoryKey;
  late int sizeBytes;
  late String source;
  String? downloadUrl;
  late bool isBundled;

  String? localPath;
  String? downloadTaskId;
  String statusKey = LibraryDownloadStatus.notDownloaded.key;
  int downloadedBytes = 0;
  int totalBytes = 0;
  DateTime updatedAt = DateTime.now();

  LibraryItemEntity toEntity() {
    return LibraryItemEntity(
      itemId: itemId,
      title: title,
      author: author,
      description: description,
      category: libraryCategoryFromKey(categoryKey) ?? LibraryCategory.translation,
      sizeBytes: sizeBytes,
      source: source,
      downloadUrl: downloadUrl,
      status: libraryDownloadStatusFromKey(statusKey),
      downloadedBytes: downloadedBytes,
      totalBytes: totalBytes,
      localPath: localPath,
      updatedAt: updatedAt,
      isBundled: isBundled,
    );
  }
}
