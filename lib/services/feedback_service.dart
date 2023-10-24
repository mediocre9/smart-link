import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_link/models/user_feedback_model.dart';

import '../models/model.dart';

abstract interface class IFeedbackService<T extends Model> {
  Future<void> post(T data);
}

class FeedbackService extends IFeedbackService<UserFeedback> {
  final FirebaseFirestore firestore;
  final CollectionReference<UserFeedback> _feedbackCollections;

  FeedbackService({required this.firestore})
      : _feedbackCollections = firestore.collection('feedback-reports').withConverter(
              fromFirestore: (snapshot, _) => UserFeedback.fromJSON(snapshot.data()!),
              toFirestore: (UserFeedback feedback, _) => feedback.toJSON(),
            );

  @override
  Future<void> post(UserFeedback data) async {
    try {
      await _feedbackCollections.doc().set(data);
    } catch (e) {
      log("FirebaseFirestore Exception: $e");
    }
  }
}
