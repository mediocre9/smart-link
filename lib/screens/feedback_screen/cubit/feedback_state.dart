part of 'feedback_cubit.dart';

sealed class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

final class FeedbackInitial extends FeedbackState {
  final Color color;

  const FeedbackInitial({required this.color});
}

final class Loading extends FeedbackState {
  final Color color;

  const Loading({required this.color});
}

final class Error extends FeedbackState {
  final String message;

  const Error({required this.message});
}

final class EmptyFieldsState extends FeedbackState {
  final Color color;

  const EmptyFieldsState({required this.color});
}

final class Submitted extends FeedbackState {
  final String message;

  const Submitted({required this.message});
}
