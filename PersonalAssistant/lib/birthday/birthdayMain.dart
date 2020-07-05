import 'package:PersonalAssistant/birthday/birthday.dart';
import 'package:flutter/material.dart';
import 'package:PersonalAssistant/birthday/dbhelper.dart';
import 'package:PersonalAssistant/birthday/birthDayDetail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BirthdayMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BirthdayMainState();
  }

}

class _BirthdayMainState extends State<BirthdayMain> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  var days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
	List<Birthday> goalList;
  int count = 0;
  var now = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    if (goalList == null) {
			goalList = List<Birthday>();
			updateListView();
		}

    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text(
          'BirthDay',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'OpenSans',
          ),
        ),
        elevation: 10.0,
      ),
      body: getBirthdayBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed:() {
          debugPrint('FAB Pressed');
          navigateToDetail(Birthday('',''), 'Add Goal');
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
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            color: Colors.orange,
                          ),
                        ),
                        TextSpan(
                          text: now.month.toString() + ' / ',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            color: Colors.orange,
                          ),
                        ),
                        TextSpan(
                          text: now.year.toString(),
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            color: Colors.orange,
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
                  fontFamily: 'OpenSans',
                  fontSize: 20.0,
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container getBirthdayBody() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
      ),
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          var date = DateTime.now();
          int differ;
          print(goalList[index].birthDate);
          String pass = goalList[index].birthDate.substring(4, goalList[index].birthDate.length);
          pass = (date.year+1).toString() + pass;
          var date2 = DateTime.parse(pass);
          var diff = date2.difference(date).inDays;
          int newdays = now.year % 4 == 0 ? 366: 365;
          if (diff >= 365) {
            diff = diff - newdays;
          }
          diff = diff + 2;
          //var date2 = DateTime.parse(goalList[index].birthDate);
          //var diff = date2.difference(date).inDays;
          
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
          child:Container(
            
            width: 150.0,
            height: 250.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    goalList[index].name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    'Next Birthday:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    diff.toString(),
                    style: TextStyle(
                      fontFamily: 'Monteserrat',
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Current Age : ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Quicksand',
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: (date.year - int.parse(goalList[index].birthDate.substring(0, 4))).toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Quicksand',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            navigateToDetail(goalList[index], 'Edit BirthDay');
          },
          onLongPress: () {
            _delete(context, goalList[index]);
          },
            ),
          );
        }
      ),
    );
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Birthday>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((goalList) {
				setState(() {
				  this.goalList = goalList;
				  this.count = goalList.length;
				});
			});
		});
  }

  void navigateToDetail(Birthday goal, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return BirthDayDetail(goal, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void _delete(BuildContext context, Birthday goal) async {

		int result = await databaseHelper.deleteNote(goal.id);
		if (result != 0) {
			_showSnackBar(context, 'Password Deleted Successfully');
			updateListView();
		}
	}

  void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 2),backgroundColor: Colors.orange,);
		Scaffold.of(context).showSnackBar(snackBar);
	}
}