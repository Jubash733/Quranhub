part of 'tadabbur_notes_cubit.dart';

class TadabburNotesState extends Equatable {
  const TadabburNotesState({required this.status});

  final ViewData<List<TadabburNoteEntity>> status;

  TadabburNotesState copyWith({
    ViewData<List<TadabburNoteEntity>>? status,
  }) {
    return TadabburNotesState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
