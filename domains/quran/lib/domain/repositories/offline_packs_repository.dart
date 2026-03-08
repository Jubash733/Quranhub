import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/pack_manifest_entity.dart';

abstract class OfflinePacksRepository {
  Future<List<PackManifestEntity>> getManifest();
  Future<bool> isPackAvailable(String editionId);
  Future<Either<FailureResponse, void>> downloadPack(String editionId);
  Future<String?> getTranslation(AyahRef ref, String editionId);
  Future<String?> getTafsir(AyahRef ref, String editionId);
}
