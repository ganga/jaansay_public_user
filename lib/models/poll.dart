import 'package:jaansay_public_user/models/poll_question.dart';

class Poll {
  String _description;
  List<PollQuestion> _questions;
  String _guid;


  String get guid => _guid;

  set guid(String value) {
    _guid = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  List<PollQuestion> get questions => _questions;

  set questions(List<PollQuestion> value) {
    _questions = value;
  }
}