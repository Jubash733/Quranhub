import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/entities/tadabbur_note_entity.dart';
import 'package:quran/domain/usecases/delete_tadabbur_note_usecase.dart';
import 'package:quran/domain/usecases/get_tadabbur_note_usecase.dart';
import 'package:quran/domain/usecases/save_tadabbur_note_usecase.dart';

part 'tadabbur_state.dart';

class TadabburCubit extends Cubit<TadabburState> {
  TadabburCubit({
    required this.getNoteUsecase,
    required this.saveNoteUsecase,
    required this.deleteNoteUsecase,
  }) : super(TadabburState(status: ViewData.initial()));

  final GetTadabburNoteUsecase getNoteUsecase;
  final SaveTadabburNoteUsecase saveNoteUsecase;
  final DeleteTadabburNoteUsecase deleteNoteUsecase;

  Future<void> loadNote(AyahRef ref, String languageCode) async {
    emit(state.copyWith(status: ViewData.loading(message: '')));
    final result =
        await getNoteUsecase.call(ref, languageCode: languageCode);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewData.error(message: failure.message),
        ),
      ),
      (note) => emit(
        state.copyWith(
          status: ViewData.loaded(data: note),
        ),
      ),
    );
  }

  Future<String?> saveNote(
    AyahRef ref,
    String languageCode,
    String text, {
    List<String> tags = const [],
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return deleteNote(ref, languageCode);
    }
    emit(state.copyWith(isSaving: true));
    final result = await saveNoteUsecase.call(
      ref,
      text: trimmed,
      tags: tags,
      languageCode: languageCode,
    );
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false));
        return failure.message;
      },
      (note) {
        emit(state.copyWith(
          isSaving: false,
          status: ViewData.loaded(data: note),
        ));
        return null;
      },
    );
  }

  Future<String?> deleteNote(AyahRef ref, String languageCode) async {
    emit(state.copyWith(isDeleting: true));
    final result =
        await deleteNoteUsecase.call(ref, languageCode: languageCode);
    return result.fold(
      (failure) {
        emit(state.copyWith(isDeleting: false));
        return failure.message;
      },
      (_) {
        emit(state.copyWith(
          isDeleting: false,
          status: ViewData.loaded(data: null),
        ));
        return null;
      },
    );
  }
}
