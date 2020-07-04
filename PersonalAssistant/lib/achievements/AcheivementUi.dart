import 'package:PersonalAssistant/achievements/achievement.dart';
//import 'package:achievement/achievement.dart';
import 'package:flutter/material.dart';
import 'package:PersonalAssistant/achievements/dbhelperAchievement.dart';
//import 'package:achievement/dbhelperAchievement.dart';
import 'package:sqflite/sqflite.dart';
import 'package:PersonalAssistant/achievements/AchievementDetail.dart';
//import 'package:achievement/AchievementDetail.dart';

class AchievementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AchievementPageState();
  }

}

class _AchievementPageState extends State<AchievementPage> {

  DatabaseHelper databaseHelper = DatabaseHelper();
	List<Achievement> noteList;
	int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
			noteList = List<Achievement>();
			updateListView();
		}
    return Scaffold(
      
      floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Achievement('', '', 1, 0), 'Add Achievement');
		    },
        backgroundColor: Colors.green,
		    tooltip: 'Add Password',

		    child: Icon(Icons.add),
        focusElevation: 10.0,
	    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset('images/r1.png', height: 50.0, width: 50.0),
            Image.asset('images/r2.png', height: 50.0, width: 50.0),
            Image.asset('images/r3.png', height: 50.0, width: 50.0),
            Image.asset('images/r4.png', height: 50.0, width: 50.0),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.black,
              floating: false,
              pinned: true,
              title: Center(
                child: Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              leading: GestureDetector(
                child: Icon(
                  Icons.arrow_back,
                ),
                onTap: () {
                  debugPrint('Back Symbol Tapped');
                  Navigator.pop(context);
                },
              ),
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    image: DecorationImage(
                      image: AssetImage('images/rankBackground.jpg'),
                      fit: BoxFit.cover,
                    )
                  ),
                  child: Image.asset(
                    'images/rankBackground.jpg',
                    height: 10.0,
                    width: 10.0,
                  ),
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children:<Widget>[
                          Image.asset(
                            noteList[index].rank == 1 ? 'images/r1.png' : noteList[index].rank == 2 ? 'images/r2.png' : noteList[index].rank == 3 ? 'images/r3.png' : 'images/r4.png',
                            height: 100.0,
                            width: 100.0, 
                          ),
                          Center(
                            child: Text(
                              noteList[index].title,
                            ),
                          )
                        ],
                      ),
                    ),
                    onLongPress: () {
                      _delete(context, noteList[index]);
                    },
                    onTap: () {
                      navigateToDetail(noteList[index], 'Edit Achievement');
                    },
                  ),
                );
              },
              childCount: count,
            ),
          ),
        ],
      ),
    );
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Achievement>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((noteList) {
        
				setState(() {
				  this.noteList = noteList;
				  this.count = noteList.length;
				});
			});
		});
  }

  void navigateToDetail(Achievement note, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return AchievementDetail(note, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void _delete(BuildContext context, Achievement note) async {

		int result = await databaseHelper.deleteNote(note.id);
		if (result != 0) {
			_showSnackBar(context, 'Password Deleted Successfully');
			updateListView();
		}
	}

  void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message), duration: const Duration(milliseconds: 1000),);
		Scaffold.of(context).showSnackBar(snackBar);
	}
}