//
//
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;
//   DatabaseHelper._internal();
//
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'auth_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }
//
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE users (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         email TEXT UNIQUE NOT NULL,
//         password TEXT NOT NULL
//       )
//     ''');
//
//     // Insert default user (email: m.billahkst@gmail.com, password: 12345)
//     await db.insert('users', {
//       'email': 'm.billahkst@gmail.com',
//       'password': '123456',
//     });
//   }
//
//   Future<Map<String, dynamic>?> getUser(String email) async {
//     Database db = await database;
//     List<Map<String, dynamic>> results = await db.query(
//       'users',
//       where: 'email = ?',
//       whereArgs: [email],
//     );
//     if (results.isNotEmpty) {
//       return results.first;
//     }
//     return null;
//   }
// }