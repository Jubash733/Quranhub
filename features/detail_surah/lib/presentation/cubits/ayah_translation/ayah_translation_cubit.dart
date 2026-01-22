import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_translation_entity.dart';
import 'package:quran/domain/usecases/get_ayah_translation_usecase.dart';

part 'ayah_translation_state.dart';

class AyahTranslationCubit extends Cubit<AyahTranslationState> {
  final GetAyahTranslationUsecase getAyahTranslationUsecase;

  AyahTranslationCubit({required this.getAyahTranslationUsecase})
      : super(AyahTranslationState(status: ViewData.initial()));

  Future<void> fetchTranslation(AyahRef ref) async {
    emit(AyahTranslationState(
        status: ViewData.loading(message: 'Loading translation')));

    final response = await getAyahTranslationUsecase.call(ref);

    response.fold(
      (failure) => emit(AyahTranslationState(
          status: ViewData.error(message: failure.message))),
      (data) => emit(AyahTranslationState(status: ViewData.loaded(data: data))),
    );
  }
}
