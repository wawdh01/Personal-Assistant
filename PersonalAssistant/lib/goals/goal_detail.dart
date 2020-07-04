import 'package:intl/intl.dart';
import 'package:PersonalAssistant/goals/Goals.dart';
import 'package:PersonalAssistant/goals/datahelper.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GoalDetail extends StatefulWidget {
  final String appBarTitle;
	final Goals goal;
  GoalDetail(this.appBarTitle, this.goal);

  @override
  State<StatefulWidget> createState() {
    return _GoalDetailState(this.appBarTitle, this.goal);
  }

}

class _GoalDetailState extends State<GoalDetail> {
  DateTime selectedDate = DateTime.now();
  DatabaseHelperGoals helper = DatabaseHelperGoals();
	String appBarTitle;
  Goals goal;
  _GoalDetailState(this.appBarTitle, this.goal);
  TextEditingController descriptionController = TextEditingController();
	TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dateController.text = goal.comDate;
		descriptionController.text = goal.description;

    return WillPopScope(
      onWillPop: () {
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
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: descriptionController,
                  onChanged: (value) {
						    	  debugPrint('Something changed in Description Text Field');
						    	  updateDescription();
						      },
                  decoration: InputDecoration(
							      labelText: 'Description',
							      labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
							      border: OutlineInputBorder(
								      borderRadius: BorderRadius.circular(5.0)
							      ),
						      ),
                ),
              ),
              Center(
                child:Text(
                  selectedDate.day.toString() + ' / ' + selectedDate.month.toString() + ' / ' + selectedDate.year.toString(),
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text('Set Date'),
              ),
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
                            updateDate();
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
            ],
          ),
        ),
	    ),

    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

  void _save() async {

		moveToLastScreen();
		int result;
		if (goal.id != null) {  // Case 1: Update operation
			result = await helper.updateNote(goal);
		} else { // Case 2: Insert Operation
			result = await helper.insertNote(goal);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Goal Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Goal');
		}

	}

	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
		// the detail page by pressing the FAB of NoteList page.
		if (goal.id == null) {
			_showAlertDialog('Status', 'No Goal was deleted');
			return;
		}

		// Case 2: User is trying to delete the old note that already has a valid ID.
		int result = await helper.deleteNote(goal.id);
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

  void updateDescription() {
		goal.description = descriptionController.text + '0';
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

    goal.date = pass;
  }
}