import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/tadabbur_note_entity.dart';
import 'package:quran/domain/usecases/get_tadabbur_notes_usecase.dart';

part 'tadabbur_notes_state.dart';

class TadabburNotesCubit extends Cubit<TadabburNotesState> {
  TadabburNotesCubit({required this.getNotesUsecase})
      : super(TadabburNotesState(status: ViewData.initial()));

  final GetTadabburNotesUsecase getNotesUsecase;

  Future<void> loadNotes({required String languageCode}) async {
    emit(state.copyWith(status: ViewData.loading(message: '')));
    final result = await getNotesUsecase.call(languageCode: languageCode);
    result.fold(
      (failure) => emit(
        state.copyWith(status: ViewData.error(message: failure.message)),
      ),
      (notes) => emit(
        state.copyWith(status: ViewData.loaded(data: notes)),
      ),
    );
  }
}
