class Poll {
  var _question;
  var _options;


  String get question => _question;
  set question(String question) {
    _question = question;
  }

  List<String> get options => _options;

  set options(List<String> options) {
    _options = options;
  }
}