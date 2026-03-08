import 'package:dependencies/isar/isar.dart';
import 'package:dependencies/path_provider/path_provider.dart';
import 'package:library_domain/data/models/library_item_model.dart';

class LibraryIsarService {
  static final LibraryIsarService _instance = LibraryIsarService._();

  LibraryIsarService._();

  factory LibraryIsarService() => _instance;

  Isar? _isar;

  Future<Isar> get instance async {
    if (_isar != null) {
      return _isar!;
    }
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [LibraryItemModelSchema],
      directory: dir.path,
      name: 'library',
    );
    return _isar!;
  }
}
