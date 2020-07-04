class Achievement {
  int _id;
  String _title;
  String _description;
  int _rank;
  int _star_rating;

  Achievement(this._title, this._description, this._rank, this._star_rating);

  Achievement.withId(this._id, this._title, this._description, this._rank, this._star_rating);

  int get id => _id;

	String get title => _title;

	String get description => _description;

	int get rank => _rank;

	int get starRating => _star_rating;


  set title(String newTitle) {
		if (newTitle.length <= 255) {
			this._title = newTitle;
		}
	}

	set description(String newDescription) {
		if (newDescription.length <= 255) {
			this._description = newDescription;
		}
	}

	set rank(int newRank) {
		this._rank = newRank;
	}

  set starRating(int newStarRating) {
    this._star_rating = newStarRating;
  }

  Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _title;
		map['description'] = _description;
		map['rank'] = _rank;
		map['starRating'] = _star_rating;

		return map;
	}

	// Extract a Note object from a Map object
	Achievement.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._title = map['title'];
		this._description = map['description'];
		this._rank = map['rank'];
		this._star_rating = map['starRating'];
	}
}