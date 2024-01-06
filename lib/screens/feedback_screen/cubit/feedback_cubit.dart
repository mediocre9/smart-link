import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_link/config/config.dart';
import 'package:smart_link/models/models.dart';
import 'package:smart_link/services/services.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackService feedbackService;
  final GoogleAuthService authService;

  FeedbackCubit({
    required this.feedbackService,
    required this.authService,
  }) : super(const FeedbackInitial(color: Colors.grey));

  Future<void> submitFeedback(String subject, String body) async {
    if (isRequiredFeedbackEmpty(subject, body)) return;

    emit(const Loading(color: Colors.blue));

    final feedback = _createUserFeedback(
      subject: subject,
      body: body,
      service: authService,
    );

    try {
      await feedbackService.post(feedback);
      emit(const Submitted(message: AppStrings.feedbackPosted));
    } on NetworkException {
      emit(const Error(message: AppStrings.noInternet));
    } catch (e) {
      emit(const Error(message: 'Something went wrong!'));
    } finally {
      emit(const FeedbackInitial(color: Colors.grey));
    }
  }

  bool isRequiredFeedbackEmpty(String subject, String body) {
    if (subject.isNotEmpty && body.isNotEmpty) {
      emit(const EmptyFieldsState(color: Colors.blue));
      return false;
    }

    emit(const FeedbackInitial(color: Colors.grey));
    return true;
  }

  DateTime _getCurrentDate() {
    final DateTime(:day, :month, :year) = DateTime.now();
    return DateTime(day, month, year);
  }

  UserFeedback _createUserFeedback({
    required String subject,
    required String body,
    required GoogleAuthService service,
  }) {
    final currentDate = _getCurrentDate();

    return UserFeedback(
      id: service.getCurrentUser!.uid,
      email: service.getCurrentUser!.email!,
      username: service.getCurrentUser!.displayName!,
      subject: subject,
      body: body,
      submittedDate: currentDate,
    );
  }
}
