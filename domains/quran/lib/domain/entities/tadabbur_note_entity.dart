import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class TadabburNoteEntity extends Equatable {
  const TadabburNoteEntity({
    required this.ref,
    required this.text,
    required this.languageCode,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
  });

  final AyahRef ref;
  final String text;
  final String languageCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;

  @override
  List<Object?> get props => [ref, text, languageCode, createdAt, updatedAt, tags];
}
