class Constituency {
  Constituency(String constituencyName) {
    this.name = constituencyName;
  }
  int _id;
  String _name;
  String _constituencyKey;

  int get id => _id;

  set id(int id) {
    _id = id;
  }

  String get name => _name;

  set name(String name) {
    _name = name;
  }

  String get constituencyKey => _constituencyKey;

  set constituencyKey(String constituencyKey) {
    _constituencyKey = constituencyKey;
  }

}