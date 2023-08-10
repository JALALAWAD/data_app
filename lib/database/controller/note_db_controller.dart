import 'package:qatar_data_app/database/db_controller.dart';
import 'package:qatar_data_app/database/db_operations.dart';
import 'package:qatar_data_app/models/note.dart';
import 'package:qatar_data_app/preferences/shared_pref_controller.dart';
import 'package:sqflite/sqflite.dart';

class NoteDbController implements DbOperations<Note> {
  final Database _database = DbController().database;

  @override
  Future<int> create(Note model) async {
    // return _database.rawInsert(
    //    'INSERT INTO notes (title , info user_id) VALUES (?,?,?)',
    //    [model.title,model.info,model.userId]);
    return _database.insert(Note.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
// DELETE FROM notes WHERE id 1 ;
//   int countOfDeletedRows = await _database.rawDelete('DELETE FROM notes WHERE id = ? ,[id]);
    int countOfDeletedRows = await _database
        .delete(Note.tableName, where: 'id = ? ', whereArgs: [id]);
    return countOfDeletedRows > 0;
  }

  @override
  Future<List<Note>> read() async {
    //SQL: SELECT / FROM notes;
    // List<Map<String,dynamic>> rowsMap =
    //     await _database.rawQuery('SELECT * FROM notes');
    // return rowsMap.map((rowMap) => Note.fromMap(rowMap)).toList();

    int userId = SharedPrefController().getValueFor(key: PrefKeys.id.name) ?? -1 ;
    List<Map<String, dynamic>> rowsMap = await _database.query(Note.tableName);
    return rowsMap.map((rowMap) => Note.fromMap(rowMap)).toList();
  }

  @override
  Future<Note?> show(int id) async {
// List<Map<String,dynamic>> rowsMap =
//     await _database.rawQuery('SELECT * FROM notes WHERE id = ? ',[id]);
    List<Map<String, dynamic>> rowsMap =
        await _database.query(Note.tableName, where: 'id = ?', whereArgs: [id]);
    return rowsMap.isNotEmpty ? Note.fromMap(rowsMap.first) : null ;
  }

  @override
  Future<bool> update(Note model) async {
    //SQL: UPDATE notes SET title = ? , info = ? ;
    //SQL: UPDATE notes SET title = ? , info = ? WHERE id = 1;
    // int countOfUpdatedRows =  await _database.rawUpdate(
    //   'UPDATE notes SET title = ? ,info = ? WHERE id = ? ' ,
    //     [model.title,model.info,model.id]);
    int countOfDeletedRows = await _database.update(
        Note.tableName, model.toMap(),
        where: 'id ? ', whereArgs: [model.id]);
    return countOfDeletedRows > 0;
  }

  /**
   * CRUD
   * C  =>  Create
   * R  =>  Read
   * U  =>  Update
   * D  =>  Delete
   */

  // Future<int> create(Note note) async {}
  // Future<List<Note>> read() async {}
  // Future<Note?> show(int id) async {}
  // Future<bool> update(Note note) async {}
  // Future<bool> delete(int id ) async {}
}
