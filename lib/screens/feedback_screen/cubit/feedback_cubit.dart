import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  }) : super(FeedbackInitial());

  Future<void> submitFeedback(String subject, String body) async {
    if (isRequiredFeedbackEmpty(subject, body)) return;

    emit(Loading());

    final feedback = _createUserFeedback(
      subject: subject,
      body: body,
      service: authService,
    );

    try {
      await feedbackService.post(feedback);
      emit(const SubmittedState(message: AppStrings.feedbackPosted));
    } on NetworkException {
      emit(const ErrorState(message: AppStrings.noInternet));
    } catch (e) {
      emit(const ErrorState(message: 'Something went wrong!'));
    } finally {
      emit(FeedbackInitial());
    }
  }

  bool isRequiredFeedbackEmpty(String subject, String body) {
    if (subject.isNotEmpty && body.isNotEmpty) {
      emit(const SubmitButtonState(color: Colors.blue));
      return false;
    }

    emit(FeedbackInitial());
    return true;
  }

  UserFeedback _createUserFeedback({
    required String subject,
    required String body,
    required GoogleAuthService service,
  }) {
    final currentDate = Timestamp.fromDate(DateTime.timestamp());
    final User(:uid, :email, :displayName) = service.getCurrentUser!;

    return UserFeedback(
      id: uid,
      email: email!,
      username: displayName!,
      subject: subject,
      body: body,
      submittedDate: currentDate,
    );
  }
}
