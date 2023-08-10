enum UserTableKeys {
  id, name , email , password , users
}
class User {
  late int id ;
  late String name ;
  late String email ;
  late String password ;

  static const tableName = 'users' ;

  User();

  User.fromMap(Map<String , dynamic> rowMap){
    id = rowMap[UserTableKeys.id.name];
    name = rowMap[UserTableKeys.name.name];
    email = rowMap[UserTableKeys.email.name];
    password = rowMap[UserTableKeys.password.name];
  }

  Map<String ,dynamic> toMap(){
    Map<String ,dynamic> map = <String,dynamic>{};
    map[UserTableKeys.name.name] = name ;
    map[UserTableKeys.email.name] = email ;
    map[UserTableKeys.password.name] = password ;
    return map;
  }
}