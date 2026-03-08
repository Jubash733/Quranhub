import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/repositories/offline_packs_repository.dart';

class GetOfflineTafsirUsecase {
  const GetOfflineTafsirUsecase({required this.repository});

  final OfflinePacksRepository repository;

  Future<String?> call(AyahRef ref, String editionId) {
    return repository.getTafsir(ref, editionId);
  }
}
