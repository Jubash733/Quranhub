import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';

class AyahAudioEntity extends Equatable {
  const AyahAudioEntity({
    required this.ref,
    required this.url,
    required this.edition,
    this.localPath,
    this.isCached = false,
  });

  final AyahRef ref;
  final String url;
  final String edition;
  final String? localPath;
  final bool isCached;

  @override
  List<Object?> get props => [ref, url, edition, localPath, isCached];
}
