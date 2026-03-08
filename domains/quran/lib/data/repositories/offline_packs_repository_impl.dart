import 'package:common/utils/error/failure_response.dart';
import 'package:dependencies/dartz/dartz.dart';
import 'package:quran/data/data_sources/quran_pack_data_source.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/pack_manifest_entity.dart';
import 'package:quran/domain/repositories/offline_packs_repository.dart';

class OfflinePacksRepositoryImpl implements OfflinePacksRepository {
  OfflinePacksRepositoryImpl({required this.packDataSource});

  final QuranPackDataSource packDataSource;

  @override
  Future<List<PackManifestEntity>> getManifest() async {
    final items = await packDataSource.getManifest();
    return items
        .map(
          (item) => PackManifestEntity(
            id: item.id,
            name: item.name,
            type: item.type,
            language: item.language,
            version: item.version,
            size: item.size,
            localPath: item.localPath,
            remoteUrl: item.remoteUrl,
            format: item.format,
            variant: item.variant,
            sourceUrl: item.sourceUrl,
          ),
        )
        .toList();
  }

  @override
  Future<bool> isPackAvailable(String editionId) {
    return packDataSource.isPackAvailable(editionId);
  }

  @override
  Future<Either<FailureResponse, void>> downloadPack(String editionId) async {
    try {
      await packDataSource.downloadPack(editionId);
      return const Right(null);
    } catch (e) {
      return Left(FailureResponse(message: e.toString()));
    }
  }

  @override
  Future<String?> getTranslation(AyahRef ref, String editionId) {
    return packDataSource.getTranslation(ref, editionId);
  }

  @override
  Future<String?> getTafsir(AyahRef ref, String editionId) {
    return packDataSource.getTafsir(ref, editionId);
  }
}
