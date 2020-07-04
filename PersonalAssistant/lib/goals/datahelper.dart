import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:PersonalAssistant/goals/Goals.dart';
import 'dart:async';

class DatabaseHelperGoals {
  static DatabaseHelperGoals _databaseHelperGoals;
  static Database _database;

  String noteTable = 'goal_table';
	String colId = 'id';
	String colDescription = 'description';
	String colDate = 'date';

  DatabaseHelperGoals._createInstance(); 

  factory DatabaseHelperGoals() {

		if (_databaseHelperGoals == null) {
			_databaseHelperGoals = DatabaseHelperGoals._createInstance(); // This is executed only once, singleton object
		}
		return _databaseHelperGoals;
	}

  Future<Database> get database async {

		if (_database == null) {
			_database = await initializeDatabase();
		}
		return _database;
	}

  Future<Database> initializeDatabase() async {
		// Get the directory path for both Android and iOS to store database.
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'goals.db';

		// Open/create the database at a given path
		var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
		return notesDatabase;
	}

  void _createDb(Database db, int newVersion) async {

		await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDescription TEXT, $colDate TEXT)');
	}

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
		Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
		var result = await db.query(noteTable, orderBy: '$colId ASC');
		return result;
	}

  Future<int> insertNote(Goals note) async {
		Database db = await this.database;
		var result = await db.insert(noteTable, note.toMap());
		return result;
	}

  // Update Operation: Update a Note object and save it to database
	Future<int> updateNote(Goals note) async {
		var db = await this.database;
		var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
		return result;
	}

  Future<int> deleteNote(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
		return result;
	}

	// Get number of Note objects in database
	Future<int> getCount() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
	Future<List<Goals>> getNoteList() async {

		var noteMapList = await getNoteMapList(); // Get 'Map List' from database
		int count = noteMapList.length;         // Count the number of map entries in db table

		List<Goals> noteList = List<Goals>();
		// For loop to create a 'Note List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			noteList.add(Goals.fromMapObject(noteMapList[i]));
		}

		return noteList;
	}
}