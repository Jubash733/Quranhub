enum LibraryCategory {
  tafsir,
  translation,
  asbab,
  irab,
  topics,
  qiraat,
}

extension LibraryCategoryX on LibraryCategory {
  String get key {
    switch (this) {
      case LibraryCategory.tafsir:
        return 'tafsir';
      case LibraryCategory.translation:
        return 'translation';
      case LibraryCategory.asbab:
        return 'asbab';
      case LibraryCategory.irab:
        return 'irab';
      case LibraryCategory.topics:
        return 'topics';
      case LibraryCategory.qiraat:
        return 'qiraat';
    }
  }
}

LibraryCategory? libraryCategoryFromKey(String? key) {
  if (key == null) return null;
  for (final value in LibraryCategory.values) {
    if (value.key == key) return value;
  }
  return null;
}
