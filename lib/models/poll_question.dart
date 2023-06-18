import 'package:jaansay_public_user/models/poll_question_option.dart';

class PollQuestion {
  String _description;
  List<PollQuestionOption> _options;
  String _guid;
  int _id;
  bool _isVoted = false;

  String _selectedOptionGuid;

  String get selectedOptionGuid => _selectedOptionGuid;

  set selectedOptionGuid(String value) {
    _selectedOptionGuid = value;
  }

  bool get isVoted => _isVoted;

  set isVoted(bool value) {
    _isVoted = value;
  }

  String get guid => _guid;

  set guid(String value) {
    _guid = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  List<PollQuestionOption> get options => _options;

  set options(List<PollQuestionOption> value) {
    _options = value;
  }
}