import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_link/config/strings/app_strings.dart';
import 'package:smart_link/services/auth_service.dart';
import 'package:smart_link/services/feedback_service.dart';

import '../../../models/user_feedback_model.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackService feedbackService;
  final FirebaseAuthService service;

  FeedbackCubit({
    required this.feedbackService,
    required this.service,
  }) : super(const FeedbackInitial(color: Colors.grey));

  Future<void> submitFeedback(String subject, String body) async {
    if (isRequiredFeedbackEmpty(subject, body)) return;

    emit(const Loading(color: Colors.blue));

    final DateTime(:year, :month, :day) = DateTime.now();

    final currentDate = DateTime(year, month, day);

    final feedback = UserFeedback(
      id: service.getUser!.uid,
      email: service.getUser!.email!,
      username: service.getUser!.displayName!,
      subject: subject,
      body: body,
      submittedDate: currentDate,
    );

    await feedbackService.post(feedback);

    emit(const Submitted(message: AppStrings.feedbackPosted));
    emit(const FeedbackInitial(color: Colors.grey));
  }

  bool isRequiredFeedbackEmpty(String subject, String body) {
    if (subject.isNotEmpty && body.isNotEmpty) {
      emit(const NonEmptyState(color: Colors.blue));
      return false;
    }

    emit(const FeedbackInitial(color: Colors.grey));
    return true;
  }
}
