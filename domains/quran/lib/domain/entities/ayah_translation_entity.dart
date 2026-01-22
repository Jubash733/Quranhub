import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class AyahTranslationEntity extends Equatable {
  const AyahTranslationEntity({
    required this.ref,
    required this.text,
    required this.languageCode,
  });

  final AyahRef ref;
  final String text;
  final String languageCode;

  @override
  List<Object?> get props => [ref, text, languageCode];
}
