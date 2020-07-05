import 'dart:async';
import 'package:flutter/material.dart';
import 'package:PersonalAssistant/birthday/birthday.dart';
import 'package:PersonalAssistant/birthday/dbhelper.dart';

class BirthDayDetail extends StatefulWidget {
  final String appBarTitle;
  final Birthday note;
  BirthDayDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return _BirthDayDetailState(this.note, this.appBarTitle);
  }

}

class _BirthDayDetailState extends State<BirthDayDetail> {
  final String appBarTitle;
  final Birthday note;
  DateTime selectedDate = DateTime.now();
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  _BirthDayDetailState(this.note, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    nameController.text = note.name;
    //dateController.text = note.birthDate;
    return WillPopScope(
      onWillPop:() {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Montserrat',
              color: Colors.white,
            ),
          ),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
            ),
            onTap: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Padding(
					        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					        child: TextField(
						        controller: nameController,
                    cursorColor: Colors.orange,
                    cursorRadius: Radius.circular(10.0),
                    showCursor: true,
						        style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
						        onChanged: (value) {
						    	    debugPrint('Something changed in Title Text Field');
						    	    updateName();
						        },
						        decoration: InputDecoration(
							        labelText: 'Birthday Boy Name',
							        labelStyle: TextStyle(
                        color: Colors.orange,
                        fontFamily: 'OpenSans',
                        fontSize: 20.0,
                      ),
							        focusedBorder: OutlineInputBorder(
								        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.orange),
							        ),
						        ),
					        ),
				        ),
                Divider(
                  thickness: 2.0,
                  color: Colors.white12,
                ),
                Center(
                  child:Text(
                    note.id == null ?
                    selectedDate.day.toString() + ' / ' + selectedDate.month.toString() + ' / ' + selectedDate.year.toString() : note.birthDate,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                  color: Colors.orange,
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    'Birthday Date',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                Divider(
                  thickness: 2.0,
                  color: Colors.white12,
                ),
                Padding(
					        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					        child: Row(
						        children: <Widget>[
						    	    Expanded(
								        child: RaisedButton(
									        color: Colors.orange,
									        child: Text(
										        'Save',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'OpenSans',
                            ),
										        textScaleFactor: 1.5,
									        ),
									        onPressed: () {
									    	    setState(() {
									    	      debugPrint("Save button clicked");
                              updateDate();
									    	      _save();
									    	    });
									        },
								        ),
							        ),

							        Container(width: 5.0,),

							        Expanded(
								        child: RaisedButton(
									        color: Colors.orange,
									        child: Text(
										        'Delete',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'OpenSans',
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
      ),
    );
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
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
      backgroundColor: Colors.deepPurple,
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

  void updateName(){
    note.name = nameController.text;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1945, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void updateDate() {
    String pass = selectedDate.year.toString();
    if (selectedDate.month < 10) {
      pass = pass + '-0' + selectedDate.month.toString();
    }
    else {
      pass = pass + '-' + selectedDate.month.toString();
    }
    if (selectedDate.day < 10) {
      pass = pass + '-0' + selectedDate.day.toString();
    }
    else {
      pass = pass + '-' + selectedDate.day.toString();
    }

    note.date = pass;
  }
}