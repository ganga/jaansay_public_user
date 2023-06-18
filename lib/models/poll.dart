import 'package:jaansay_public_user/models/poll_question.dart';

class Poll {
  String _description;
  List<PollQuestion> _questions;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  List<PollQuestion> get questions => _questions;

  set questions(List<PollQuestion> value) {
    _questions = value;
  }
}