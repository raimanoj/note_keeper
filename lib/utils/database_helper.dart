import 'dart:io';
import 'package:note_keeper/model/Note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database database, int newVersion) async {
    await database.execute(
        "create table table_note(id integer primary key autoincrement, title text, description text,"
        "priority integer, date text, image_path text)");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery("select * from table_note order by priority asc");
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    int result = await db.insert("table_note", note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await this.database;
    int result = await db.update("table_note", note.toMap(),
        where: "id = ?", whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db.rawDelete("delete from table_note where id = $id");
    return result;
  }

  Future<int> getCount() async {
    var db = await this.database;
    List<Map<String, dynamic>> list =
        await db.rawQuery("select count(*) from table_note");
    int result = Sqflite.firstIntValue(list);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    List<Note> noteList = List<Note>();
    for (var fromMapList in noteMapList) {
      noteList.add(Note.fromMapObject(fromMapList));
    }
    return noteList;
  }
}
