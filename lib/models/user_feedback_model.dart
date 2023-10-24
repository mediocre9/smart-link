import 'package:smart_link/models/model.dart';

final class UserFeedback extends Model {
  final String email;
  final String username;
  final String subject;
  final String body;
  final DateTime submittedDate;

  UserFeedback({
    required super.id,
    required this.email,
    required this.username,
    required this.subject,
    required this.body,
    required this.submittedDate,
  });

  factory UserFeedback.fromJSON(Map<String, dynamic> data) {
    return UserFeedback(
      id: data["userId"],
      email: data["email"],
      username: data["username"],
      subject: data["subject"],
      body: data["body"],
      submittedDate: data["submittedDate"],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "userId": id,
      "username": username,
      "submittedDate": submittedDate,
      "email": email,
      "subject": subject,
      "body": body,
    };
  }
}
