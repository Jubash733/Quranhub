import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/equatable/equatable.dart';
import 'package:quran/domain/entities/ai_tadabbur_entity.dart';
import 'package:quran/domain/entities/ayah_ref.dart';
import 'package:quran/domain/usecases/get_ai_tadabbur_usecase.dart';

part 'ai_assistant_state.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  final GetAiTadabburUsecase getAiTadabburUsecase;

  AiAssistantCubit({required this.getAiTadabburUsecase})
      : super(AiAssistantState(status: ViewData.initial()));

  Future<void> generate(
    AyahRef ref,
    String languageCode, {
    String? userPrompt,
  }) async {
    emit(AiAssistantState(status: ViewData.loading(message: '')));

    final result = await getAiTadabburUsecase.call(
      ref,
      languageCode: languageCode,
      userPrompt: userPrompt,
    );

    result.fold(
      (failure) => emit(
        AiAssistantState(status: ViewData.error(message: failure.message)),
      ),
      (data) => emit(AiAssistantState(status: ViewData.loaded(data: data))),
    );
  }

  void reset() {
    emit(AiAssistantState(status: ViewData.initial()));
  }
}
