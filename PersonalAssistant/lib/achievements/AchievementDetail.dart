import 'dart:async';
import 'package:flutter/material.dart';
import 'package:PersonalAssistant/achievements/dbhelperAchievement.dart';
import 'package:PersonalAssistant/achievements/achievement.dart';
//import 'package:achievement/dbhelperAchievement.dart';
//import 'package:achievement/achievement.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AchievementDetail extends StatefulWidget {
  final String appBarTitle;
  final Achievement note;
  AchievementDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return _AchievementDetailState(this.note, this.appBarTitle);
  }

}

class _AchievementDetailState extends State<AchievementDetail> {
  DatabaseHelper helper = DatabaseHelper();
	String appBarTitle;
	Achievement note;
  int value;

  TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();
  TextEditingController rankController = TextEditingController();
  TextEditingController starRatingController = TextEditingController();

	_AchievementDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {

    titleController.text = note.title;
		descriptionController.text = note.description;
    rankController.text = note.rank.toString();
    value = note.starRating;
    
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
		      title: Text(
            appBarTitle,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Quicksand',
              color: Colors.white,
            ),
          ),
		      leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    // Write some code to control things, when user press back button in AppBar
		    	    moveToLastScreen();
				    }
		      ),
	      ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children:<Widget>[
              Padding(
					      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					      child: TextField(
						      controller: titleController,
                  showCursor: true,
                  cursorColor: Colors.green,
						      style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
						      onChanged: (value) {
						    	  debugPrint('Something changed in Title Text Field');
						    	  updateTitle();
						      },
						      decoration: InputDecoration(
							      labelText: 'Title',
							      labelStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
							      focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.green),
                    ),
						      ),
					      ),
				      ),
              Padding(
					      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					      child: TextField(
                  showCursor: true,
                  cursorColor: Colors.green,
						      controller: descriptionController,
						      style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
						      onChanged: (value) {
						    	  debugPrint('Something changed in Description Text Field');
						    	  updateDescription();
						      },
						      decoration: InputDecoration(
							      labelText: 'Description',
							      labelStyle: TextStyle(),
							      focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.green),
                    )
						      ),
					      ),
				      ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Rank(Number)',
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        showCursor: true,
                        cursorColor: Colors.green,
                        controller: rankController,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged:(value) {
                          debugPrint('Changed Rank');
                          updateRank();
                        },
                        decoration: InputDecoration(
                          labelText: 'Rank',
							            labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
							            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'How much would you rate Your Achievement ? ',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                          fontSize: 15.0,
                          color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: SmoothStarRating(
                  allowHalfRating: false,
                  onRated:(v) {
                    print(v);
                    updateStarRating(v);
                    //value = v;
                  },
                  rating: value.toDouble(),
                  size: 40.0,
                  isReadOnly: false,
                  color: Colors.green,
                  borderColor: Colors.white10,
                  spacing: 5.0,
                ),
              ),

              Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Colors.green,
									    child: Text(
										    'Save',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Save button clicked");
									    	  _save();
									    	});
									    },
								    ),
							    ),

							    Container(width: 5.0,),

							    Expanded(
								    child: RaisedButton(
                      color: Colors.green,
									    child: Text(
										    'Delete',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
										    textScaleFactor: 1.5,
									    ),
									    onPressed: () {
										    setState(() {
											    debugPrint("Delete button clicked");
											    _delete();
										    });
									    },
								    ),
							    ),
						    ],
					    ),
				    ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

  void updateTitle(){
    note.title = titleController.text;
  }

	// Update the description of Note object
	void updateDescription() {
		note.description = descriptionController.text;
	}

  //update the Rank 
  void updateRank() {
    note.rank = int.parse(rankController.text);
  }

  void updateStarRating(double v) {
    note.starRating = v.toInt();
  }

  void _save() async {

		moveToLastScreen();
		int result;
		if (note.id != null) {  // Case 1: Update operation
			result = await helper.updateNote(note);
		} else { // Case 2: Insert Operation
			result = await helper.insertNote(note);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Achievement Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Achievemet');
		}

	}

	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
		// the detail page by pressing the FAB of NoteList page.
		if (note.id == null) {
			_showAlertDialog('Status', 'No Password was deleted');
			return;
		}

		// Case 2: User is trying to delete the old note that already has a valid ID.
		int result = await helper.deleteNote(note.id);
		if (result != 0) {
			_showAlertDialog('Status', 'Password Deleted Successfully');
		} else {
			_showAlertDialog('Status', 'Error Occured while Deleting Password');
		}
	}

  void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
      elevation: 10.0,
      backgroundColor: Colors.green,
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

}