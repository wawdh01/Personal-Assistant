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
        title: Text(
          'My Goals',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'OpenSans',
          ),
        ),
        elevation: 10.0,
      ),
      body: getGoalsBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
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
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'OpenSans',
                            color: Colors.greenAccent,
                          ),
                        ),
                        TextSpan(
                          text: now.month.toString() + ' / ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'OpenSans',
                            color: Colors.greenAccent,
                          ),
                        ),
                        TextSpan(
                          text: now.year.toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'OpenSans',
                            color: Colors.greenAccent,
                          ),
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
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'OpenSans',
                  color: Colors.greenAccent,
                ),
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
              height: 200.0,
              child: Column(
                children:<Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          goalList[position].description.substring(0, goalList[position].description.length - 1),
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 30.0,
                            color: Colors.black,
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
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Text.rich(
                      TextSpan(
                        children:<TextSpan>[
                          TextSpan(
                            text: 'Date: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Raleway',
                              fontSize: 15.0,
                            ),
                          ),
                          TextSpan(
                            text: goalList[position].comDate,
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child:Text.rich(
                      TextSpan(
                        children:<TextSpan>[
                          TextSpan(
                            text: 'Days Remaining : ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Raleway',
                              fontSize: 15.0,
                            ),
                          ),
                          TextSpan(
                            text: '  ' + diff.toString(),
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Divider(
                    thickness: 2.0,
                    color: Colors.white12,
                  ),
                  Center(
                    widthFactor: 2.0,
                    child:Row(
                      children: <Widget>[
                        Checkbox(
                          value: goalList[position].description.substring(goalList[position].description.length - 1, goalList[position].description.length) == '0' ? false:true,
                          onChanged: (bool e) => doChanged(goalList[position]),
                          activeColor: Colors.greenAccent,
                        ),
                        Text(
                          goalList[position].description.substring(goalList[position].description.length - 1, goalList[position].description.length) == '0' ? 'Not Completed': 'Completed',
                          style: TextStyle(
                            color: goalList[position].description.substring(goalList[position].description.length - 1, goalList[position].description.length) == '0' ? Colors.red:Colors.green,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
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

		final snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 2), backgroundColor: Colors.greenAccent,);
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
          height: 150.0,
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Congrats....!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  'You have Completed your Goal.',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 15.0,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                color: Colors.greenAccent,
                child: Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'Montserrat',
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