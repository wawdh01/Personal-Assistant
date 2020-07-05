import 'dart:async';
import 'package:flutter/material.dart';
import 'package:PersonalAssistant/password/models/note.dart';
import 'package:PersonalAssistant/password/utils/database_helper.dart';
import 'package:PersonalAssistant/password/screens/note_detail.dart';
//import 'package:flutter_app/models/note.dart';
//import 'package:flutter_app/utils/database_helper.dart';
//import 'package:flutter_app/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {

	@override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Note> noteList;
	int count = 0;

	@override
  Widget build(BuildContext context) {

		if (noteList == null) {
			noteList = List<Note>();
			updateListView();
		}

    return Scaffold(

	    appBar: AppBar(
		    title: Text(
          'Password',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'OpenSans',
          ),
        ),
	    ),

	    body: getNoteListView(),

	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Note('', '', 2), 'Add Password');
		    },

		    tooltip: 'Add Password',
        backgroundColor: Colors.blue,
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
            Text(
              'Password',
              style: TextStyle(
                color: Colors.blue,
                fontFamily: 'Montserrat',
                fontSize: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView getNoteListView() {

		TextStyle titleStyle = Theme.of(context).textTheme.subhead;

		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				return Card(
          borderOnForeground: true,
					color: Colors.grey[700],
					elevation: 2.0,
					child: ListTile(
						leading: CircleAvatar(
							backgroundColor: getPriorityColor(this.noteList[position].priority),
							child: getPriorityIcon(this.noteList[position].priority),
						),

						title: Text(
              this.noteList[position].title,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20.0,
                fontFamily: 'OpenSans',
              ),
            ),

						subtitle: Text(
              this.noteList[position].date,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontFamily: 'OpenSans',
              ),
            ),

						trailing: GestureDetector(
							child: Icon(Icons.delete, color: Colors.red,),
							onTap: () {
								_delete(context, noteList[position]);
							},
						),


						onTap: () {
							debugPrint("ListTile Tapped");
							navigateToDetail(this.noteList[position],'Edit Password');
						},

					),
				);
			},
		);
  }

  // Returns the priority color
	Color getPriorityColor(int priority) {
		switch (priority) {
			case 1:
				return Colors.blue;
				break;
			case 2:
				return Colors.blue;
				break;

			default:
				return Colors.blue;
		}
	}

	// Returns the priority icon
	Icon getPriorityIcon(int priority) {
		switch (priority) {
			case 1:
				return Icon(Icons.lock, color: Colors.red,);
				break;
			case 2:
				return Icon(Icons.lock, color: Colors.green);
				break;

			default:
				return Icon(Icons.lock, color: Colors.green);
		}
	}

	void _delete(BuildContext context, Note note) async {

		int result = await databaseHelper.deleteNote(note.id);
		if (result != 0) {
			_showSnackBar(context, 'Password Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message), duration: Duration(seconds: 1),backgroundColor: Colors.blue,);
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Note note, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NoteDetail(note, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((noteList) {
				setState(() {
				  this.noteList = noteList;
				  this.count = noteList.length;
				});
			});
		});
  }
}
