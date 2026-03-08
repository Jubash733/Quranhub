import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/ayah_tafsir_entity.dart';
import 'package:quran/domain/usecases/get_ayah_tafsir_usecase.dart';

part 'ayah_tafsir_state.dart';

class AyahTafsirCubit extends Cubit<AyahTafsirState> {
  final GetAyahTafsirUsecase getAyahTafsirUsecase;

  AyahTafsirCubit({required this.getAyahTafsirUsecase})
      : super(AyahTafsirState(status: ViewData.initial()));

  Future<void> fetchTafsir(AyahRef ref, String languageCode) async {
    emit(AyahTafsirState(status: ViewData.loading(message: '')));

    final response =
        await getAyahTafsirUsecase.call(ref, languageCode: languageCode);

    response.fold(
      (failure) => emit(
        AyahTafsirState(status: ViewData.error(message: failure.message)),
      ),
      (data) {
        final text = data.text.trim();
        if (text.isNotEmpty) {
          final firstLine = text.split('\n').first.trim();
          if (firstLine.isNotEmpty) {
            debugPrint(
              'Tafsir ${ref.surah}:${ref.ayah} -> $firstLine',
            );
          }
        }
        emit(AyahTafsirState(status: ViewData.loaded(data: data)));
      },
    );
  }
}
