import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbController {
  static DbController? _instance;
  late Database _database;

  DbController._();

  factory DbController() {
    return _instance ??= DbController._();
  }

  Database get database => _database;

  Future<void> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,'app_db.sql');
    _database = await  openDatabase(
        path,
        version: 1,
        onOpen: (Database database) {},
      onCreate: (Database database ,int version) async {
await database.execute('CREATE TABLE users ('
    'id INTEGER PRIMARY KEY AUTOINCREMENT,'
    'name TEXT NOT NULL,'
    'email TEXT NOT NULL,'
    'password TEXT NOT NULL'
    ')');

await database.execute('CREATE TABLE notes('
    'id INTEGER PRIMARY KEY AUTOINCREMENT,'
    'title TEXT NOT NULL,'
    'info TEXT NOT NULL,'
    'user_id INTEGER,'
'FOREIGN KEY (user_id) references users(id)'
    ')');
      },
      onUpgrade: (Database db ,int oldVersion , int newVersion) {},
      onDowngrade: (Database db ,int oldVersion , int newVersion) {},
    );
  }
}