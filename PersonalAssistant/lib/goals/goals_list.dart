import 'package:flutter/material.dart';
import 'package:PersonalAssistant/goals/datahelper.dart';
import 'package:PersonalAssistant/goals/Goals.dart';
import 'package:PersonalAssistant/goals/display_done.dart';
import 'package:PersonalAssistant/goals/goal_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class goalsList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _goalsListState();
  }

}

class _goalsListState extends State<goalsList> {

  DatabaseHelperGoals databaseHelper = DatabaseHelperGoals();
  var days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
	List<Goals> goalList;
  int count = 0;
  var now = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    if (goalList == null) {
			goalList = List<Goals>();
			updateListView();
		}

    return Scaffold(
      appBar: AppBar(
        title: Text('My Goals'),
        elevation: 10.0,
      ),
      body: getGoalsBody(),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          debugPrint('FAB Pressed');
          navigateToDetail(Goals('',''), 'Add Goal');
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 50.0,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text.rich(
                    TextSpan(
                      children:<TextSpan>[
                        TextSpan(
                          text: now.day.toString() + ' / ',
                          style: TextStyle(),
                        ),
                        TextSpan(
                          text: now.month.toString() + ' / ',
                          style: TextStyle(),
                        ),
                        TextSpan(
                          text: now.year.toString(),
                          style: TextStyle(),
                        ),
                      ],
                    ),
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Text(
                days[now.weekday - 1],
                style: TextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container getGoalsBody() {
    return Container(
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          var date = DateTime.now();
          print(goalList[position].comDate);
          var date2 = DateTime.parse(goalList[position].comDate);
          var diff = date2.difference(date).inDays;
          return Card(
            child: Container(
              height: 170.0,
              child: Column(
                children:<Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          goalList[position].description.substring(0, goalList[position].description.length - 1),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      onLongPress: () {
                        _delete(context, goalList[position]);
                      },
                      onTap: () {
                        navigateDetail(goalList[position], 'Edit Goal');
                      },
                    ),
                  ),
                  Container(
                    child: Text.rich(
                      TextSpan(
                        children:<TextSpan>[
                          TextSpan(
                            text: 'Date: ',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: goalList[position].comDate,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Days Remaining:\n',
                    style: TextStyle(),
                  ),
                  Center(
                    child:Text(
                      diff.toString(),
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: goalList[position].description.substring(goalList[position].description.length - 1, goalList[position].description.length) == '0' ? false:true,
                        onChanged: (bool e) => doChanged(goalList[position]),
                      ),
                      Text(
                        goalList[position].description.substring(goalList[position].description.length - 1, goalList[position].description.length) == '0' ? 'Not Completed': 'Completed',
                        style: TextStyle(
                          color: goalList[position].description.substring(goalList[position].description.length - 1, goalList[position].description.length) == '0' ? Colors.red:Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Goals>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((goalList) {
				setState(() {
				  this.goalList = goalList;
				  this.count = goalList.length;
				});
			});
		});
  }

  void navigateToDetail(Goals goal, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return GoalDetail(title, goal);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void _delete(BuildContext context, Goals goal) async {

		int result = await databaseHelper.deleteNote(goal.id);
		if (result != 0) {
			_showSnackBar(context, 'Password Deleted Successfully');
			updateListView();
		}
	}

  void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 2),);
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void doChanged(Goals temp) async {
    String pass = temp.description.substring(0, temp.description.length - 1);
    String temp1 = temp.description.substring(temp.description.length - 1, temp.description.length);
    if (temp1 == '0') {
      pass = pass + '1';
      Navigator.push(context, PageRouteBuilder(
        opaque: false,
        pageBuilder:(BuildContext context,_, __) {
          return showMessageScaffold();
        }
      ));
    } 
    else {
      pass = pass + '0';
    }
    temp.description = pass;
    int result = await databaseHelper.updateNote(temp);
    setState(() {
      
    });
  }

  Material showMessageScaffold() {
    return Material(
      type: MaterialType.transparency,
      child: showMessage(),
    );
  }
  Container showMessage() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        image: DecorationImage(
          image: AssetImage('images/background.gif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Congrats....!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'You have Completed your Goal.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
              RaisedButton(
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateDetail(Goals note, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return GoalDetail(title, note);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }
}