class Goals {
  int _id;
  String _description;
  String _comDate;

  Goals(this._description, this._comDate);

  Goals.withId(this._id, this._description, this._comDate);

  int get id => _id;

	String get description => _description;

  String get comDate => _comDate;

  set description(String newDescription) {
		this._description = newDescription;
	}

  set date(String newDate) {
		this._comDate = newDate;
	}

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
    map['description'] = _description;
    map['date'] = _comDate;
    return map;
  }

  Goals.fromMapObject (Map<String, dynamic> map) {
    this._id = map['id'];
    this._description = map['description'];
    this._comDate = map['date'];
  }
}