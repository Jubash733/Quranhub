import 'package:dependencies/equatable/equatable.dart';

class AyahRef extends Equatable {
  const AyahRef({
    required this.surah,
    required this.ayah,
  });

  final int surah;
  final int ayah;

  @override
  List<Object?> get props => [surah, ayah];
}
