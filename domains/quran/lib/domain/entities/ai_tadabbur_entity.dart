import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class AiTadabburEntity extends Equatable {
  const AiTadabburEntity({
    required this.ref,
    required this.response,
    required this.languageCode,
    required this.createdAt,
    required this.promptType,
    required this.promptVersion,
  });

  final AyahRef ref;
  final String response;
  final String languageCode;
  final DateTime createdAt;
  final String promptType;
  final String promptVersion;

  @override
  List<Object?> get props =>
      [ref, response, languageCode, createdAt, promptType, promptVersion];
}
