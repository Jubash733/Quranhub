part of 'ayah_translation_cubit.dart';

class AyahTranslationState extends Equatable {
  final ViewData<AyahTranslationEntity> status;

  const AyahTranslationState({required this.status});

  @override
  List<Object?> get props => [status];
}
