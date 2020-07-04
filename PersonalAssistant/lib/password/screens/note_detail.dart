import 'dart:async';
import 'package:flutter/material.dart';
import 'package:PersonalAssistant/password/models/note.dart';
import 'package:PersonalAssistant/password/utils/database_helper.dart';
//import 'package:flutter_app/models/note.dart';
//import 'package:flutter_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {

	final String appBarTitle;
	final Note note;

	NoteDetail(this. note, this.appBarTitle);

	@override
  State<StatefulWidget> createState() {

    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String pass = null;
  int per = 0;
  double perdo = 0;
	static var _priorities = ['High', 'Low'];

	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Note note;

	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();

	NoteDetailState(this.note, this.appBarTitle);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = Theme.of(context).textTheme.title;

		titleController.text = note.title;
		descriptionController.text = note.description;

    return WillPopScope(

	    onWillPop: () {
	    	// Write some code to control things, when user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    title: Text(appBarTitle),
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    // Write some code to control things, when user press back button in AppBar
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[

			    	// First element
				    ListTile(
					    title: DropdownButton(
							    items: _priorities.map((String dropDownStringItem) {
							    	return DropdownMenuItem<String> (
									    value: dropDownStringItem,
									    child: Text(dropDownStringItem),
								    );
							    }).toList(),

							    style: textStyle,

							    value: getPriorityAsString(note.priority),

							    onChanged: (valueSelectedByUser) {
							    	setState(() {
							    	  debugPrint('User selected $valueSelectedByUser');
							    	  updatePriorityAsInt(valueSelectedByUser);
							    	});
							    }
					    ),
				    ),

				    // Second Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: titleController,
						    style: textStyle,
						    onChanged: (value) {
						    	debugPrint('Something changed in Title Text Field');
						    	updateTitle();
						    },
						    decoration: InputDecoration(
							    labelText: 'Username or Email',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
					    ),
				    ),

				    // Third Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: descriptionController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in Description Text Field');
							    updateDescription();
						    },
						    decoration: InputDecoration(
								    labelText: 'Password',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(5.0)
								    )
						    ),
					    ),
				    ),

				    // Fourth Element
				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: RaisedButton(
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Save',
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
									    color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
									    child: Text(
										    'Delete',
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
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
								child: Text(
									'Check Strength',
									textScaleFactor: 1.5,
								),
                onPressed: () {
                  setState(() {
                    pass = descriptionController.text;
                    strengthCal(pass);
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[850]),
                ),
                height: 15.0,
                width: 10.0,
                child: progressBar(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 20.0,
                      height: 20.0,
                      color: Colors.red,
                    ),
                    title: Text('Weak Password'),
                  ),
                  ListTile(
                    leading: Container(
                      width: 20.0,
                      height: 20.0,
                      color: Colors.deepPurple,
                    ),
                    title: Text('Moderate Password'),
                  ),
                  ListTile(
                    leading: Container(
                      width: 20.0,
                      height: 20.0,
                      color: Colors.green,
                    ),
                    title: Text('Strong Password'),
                  ),
                ],
              ),
            ),
			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

	// Convert the String priority in the form of integer before saving it to Database
	void updatePriorityAsInt(String value) {
		switch (value) {
			case 'High':
				note.priority = 1;
				break;
			case 'Low':
				note.priority = 2;
				break;
		}
	}

	// Convert int priority to String priority and display it to user in DropDown
	String getPriorityAsString(int value) {
		String priority;
		switch (value) {
			case 1:
				priority = _priorities[0];  // 'High'
				break;
			case 2:
				priority = _priorities[1];  // 'Low'
				break;
		}
		return priority;
	}

	// Update the title of Note object
  void updateTitle(){
    note.title = titleController.text;
  }

	// Update the description of Note object
	void updateDescription() {
		note.description = descriptionController.text;
	}

	// Save data to database
	void _save() async {

		moveToLastScreen();

		note.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (note.id != null) {  // Case 1: Update operation
			result = await helper.updateNote(note);
		} else { // Case 2: Insert Operation
			result = await helper.insertNote(note);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Password Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Password');
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
      backgroundColor: Colors.deepPurple,
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

  void strengthCal(String password) {
    int i = 0;
    int lowChar = 0;
    int upChar= 0;
    int speChar = 0;
    int numChar = 0;
    int j = password.length;
    for (i = 0; i < j ; i++) {
      if (password.codeUnitAt(i) > 47 && password.codeUnitAt(i) < 58) {
        numChar = numChar + 2;
      }
      else if (password.codeUnitAt(i) > 64 && password.codeUnitAt(i) < 90) {
        upChar = upChar + 1;
      }
      else if (password.codeUnitAt(i) > 96 && password.codeUnitAt(i) < 123) {
        lowChar = lowChar + 1;
      }
      else {
        speChar = speChar + 15;
      }
    }
    per = numChar + upChar + lowChar + speChar;
    if (per > 100) {
      per = 100;
    }
    print(per);
  }

  LinearProgressIndicator progressBar () {
    perdo = per.toDouble();
    perdo = perdo/100;
    setState(() {
      
    });
    return LinearProgressIndicator(
      value: perdo,
      backgroundColor: Colors.white,
      valueColor: (perdo*100).toInt() < 25 ? AlwaysStoppedAnimation<Color>(Colors.red) : (perdo*100).toInt() < 60 ? AlwaysStoppedAnimation<Color>(Colors.deepPurple) : AlwaysStoppedAnimation<Color>(Colors.green),
      semanticsLabel: 'Password Strength',
      semanticsValue: perdo.toString(),
    );
    
  }
}