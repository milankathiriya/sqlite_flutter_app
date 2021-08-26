import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:triputi_app/models/student_model.dart';

class DBHelper {
  DBHelper._();
  String TABLE = "students";
  var database;

  Future<Database> initDB() async {
    if (database != null) {
      return database;
    } else {
      var db = openDatabase(
        join(await getDatabasesPath(), 'stu_db.db'),
        version: 1,
        onCreate: (db, ver) {
          String sql =
              "CREATE TABLE students(id INTEGER, name TEXT, age INTEGER, PRIMARY KEY ('id' AUTOINCREMENT))";
          return db.execute(sql);
        },
      );
      return db;
    }
  }

  Future<int> insertData(Student s) async {
    var db = await initDB();

    String query =
        "INSERT INTO $TABLE(name, age) VALUES('${s.name}', ${s.age})";
    int insertedID = await db.rawInsert(query);
    return insertedID;
  }

  getAllStudents() async {
    var db = await initDB();

    String query = "SELECT * FROM $TABLE";
    List<Map<String, dynamic>> res = await db.rawQuery(query);

    var response = res.map((record) => Student.fromMap(record)).toList();

    print(response);
  }
}

DBHelper dbh = DBHelper._();
