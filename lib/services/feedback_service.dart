import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_link/models/models.dart';
import 'package:smart_link/services/services.dart';

abstract interface class IFeedbackService<T extends Model> {
  Future<void> post(T data);
}

class FeedbackService extends IFeedbackService<UserFeedback> {
  final FirebaseFirestore firestore;
  final CollectionReference<UserFeedback> _feedbackCollections;
  final IConnectivityService connectivityService;

  FeedbackService({
    required this.connectivityService,
    required this.firestore,
  }) : _feedbackCollections =
            firestore.collection('feedback-reports').withConverter(
                  fromFirestore: (snapshot, _) =>
                      UserFeedback.fromJSON(snapshot.data()!),
                  toFirestore: (UserFeedback feedback, _) => feedback.toJSON(),
                );

  @override
  Future<void> post(UserFeedback data) async {
    try {
      if (await connectivityService.isOffline()) throw NetworkException();
      await _feedbackCollections.doc().set(data);
    } catch (e) {
      log("Feedback Exception: $e");
      rethrow;
    }
  }
}
