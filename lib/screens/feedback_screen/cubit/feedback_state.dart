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

final class NonEmptyState extends FeedbackState {
  final Color color;

  const NonEmptyState({required this.color});
}

final class Submitted extends FeedbackState {
  final String message;

  const Submitted({required this.message});
}
