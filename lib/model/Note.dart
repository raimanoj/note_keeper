class Note {
  int _id;
  String _title;
  String _descriptions;
  String _date;
  int _priority;
  String _imagePath;

  Note(this._title, this._date, this._priority, [this._descriptions]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._descriptions]);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get descriptions => _descriptions;

  set descriptions(String value) {
    _descriptions = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  int get priority => _priority;

  set priority(int value) {
    _priority = value;
  }


  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map["id"] = _id;
    map["title"] = _title;
    map["description"] = _descriptions;
    map["priority"] = _priority;
    map["date"] = _date;
    map["image_path"] = _imagePath;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._title = map["title"];
    this._descriptions = map["description"];
    this._priority = map["priority"];
    this._date = map["date"];
    this._imagePath = map["image_path"];
  }
}
