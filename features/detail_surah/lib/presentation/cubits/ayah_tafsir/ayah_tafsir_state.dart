part of 'ayah_tafsir_cubit.dart';

class AyahTafsirState extends Equatable {
  final ViewData<AyahTafsirEntity> status;

  const AyahTafsirState({required this.status});

  @override
  List<Object?> get props => [status];
}
