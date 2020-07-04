class Birthday {
  int _id;
  String _name;
  String _birthdate;
  
  Birthday(this._name, this._birthdate);

  Birthday.withId(this._id, this._name, this._birthdate);

  int get id => _id;

	String get name => _name;

  String get birthDate => _birthdate;

  set name(String newName) {
    this._name = newName;
  }

  set date(String newDate) {
		this._birthdate = newDate;
	}

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
    map['name'] = _name;
    map['birthdate'] = _birthdate;
    return map;
  }

  Birthday.fromMapObject (Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._birthdate = map['birthdate'];
  }
}