part of 'feedback_cubit.dart';

sealed class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

final class FeedbackInitial extends FeedbackState {}

final class Loading extends FeedbackState {}

final class ErrorState extends FeedbackState {
  final String message;

  const ErrorState({required this.message});
}

final class SubmitButtonState extends FeedbackState {
  final Color color;

  const SubmitButtonState({required this.color});
}

final class SubmittedState extends FeedbackState {
  final String message;

  const SubmittedState({required this.message});
}
