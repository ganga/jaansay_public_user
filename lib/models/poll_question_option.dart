class PollQuestionOption {
  String _description;
  int _order;
  int _id;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  int get order => _order;

  set order(int value) {
    _order = value;
  }
}