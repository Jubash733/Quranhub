part of 'tadabbur_cubit.dart';

class TadabburState extends Equatable {
  const TadabburState({
    required this.status,
    this.isSaving = false,
    this.isDeleting = false,
  });

  final ViewData<TadabburNoteEntity?> status;
  final bool isSaving;
  final bool isDeleting;

  TadabburState copyWith({
    ViewData<TadabburNoteEntity?>? status,
    bool? isSaving,
    bool? isDeleting,
  }) {
    return TadabburState(
      status: status ?? this.status,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [status, isSaving, isDeleting];
}
