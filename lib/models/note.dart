import 'package:async/async.dart';

enum NoteTableKeys {
  id, title , info , user_id
}

class Note {

  late int id ;
  late String title ;
  late String info ;
  late int userId ;

  static const tableName = 'notes';

  Note();

  Note.fromMap(Map<String , dynamic> rowMap){
    id = rowMap[NoteTableKeys.id.name];
    title = rowMap[NoteTableKeys.title.name];
    info = rowMap[NoteTableKeys.info.name];
    userId = rowMap[NoteTableKeys.user_id.name];
  }

  Map<String ,dynamic> toMap(){
    Map<String ,dynamic> map = <String,dynamic>{};
    map[NoteTableKeys.title.name] = title ;
    map[NoteTableKeys.info.name] = info ;
    map[NoteTableKeys.user_id.name] = userId ;
    return map;
  }
}