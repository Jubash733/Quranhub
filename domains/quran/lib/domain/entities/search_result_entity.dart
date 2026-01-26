import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class SearchResultEntity extends Equatable {
  const SearchResultEntity({
    required this.ref,
    required this.surahName,
    required this.text,
    required this.translation,
  });

  final AyahRef ref;
  final String surahName;
  final String text;
  final String translation;

  @override
  List<Object?> get props => [ref, surahName, text, translation];
}
