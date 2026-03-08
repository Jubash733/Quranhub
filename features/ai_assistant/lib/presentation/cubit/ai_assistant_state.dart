part of 'ai_assistant_cubit.dart';

class AiAssistantState extends Equatable {
  final ViewData<AiTadabburEntity> status;

  const AiAssistantState({required this.status});

  @override
  List<Object?> get props => [status];
}
