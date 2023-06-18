import 'package:jaansay_public_user/models/poll_question_option.dart';

class PollQuestion {
  String _description;
  List<PollQuestionOption> _options;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  List<PollQuestionOption> get options => _options;

  set options(List<PollQuestionOption> value) {
    _options = value;
  }
}