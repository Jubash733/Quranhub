import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class AyahTafsirEntity extends Equatable {
  const AyahTafsirEntity({
    required this.ref,
    required this.text,
  });

  final AyahRef ref;
  final String text;

  @override
  List<Object?> get props => [ref, text];
}
