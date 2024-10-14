import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabaseHelper {
  static final TodoDatabaseHelper _instance = TodoDatabaseHelper._internal();
  static Database? _database;

  TodoDatabaseHelper._internal();

  factory TodoDatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(
      path,
      version: 6, // Increment version number for schema change
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        value TEXT UNIQUE,
        description TEXT,
        date TEXT,
        image TEXT, 
        isDeleting INTEGER,
        isFavourite INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        otp TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE remember_me(
        email TEXT PRIMARY KEY,
        password TEXT,
        remember_me INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE app_info(
        key TEXT PRIMARY KEY,
        value INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE tasks ADD COLUMN description TEXT
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE tasks ADD COLUMN date TEXT
      ''');
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT NOT NULL,
          password TEXT NOT NULL,
          otp TEXT
        )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE remember_me(
          email TEXT PRIMARY KEY,
          password TEXT,
          remember_me INTEGER
        )
      ''');
    }
    if (oldVersion < 5) {
      await db.execute('''
        ALTER TABLE tasks ADD COLUMN image TEXT
      ''');
    }
    if (oldVersion < 6) {
      await db.execute('''
        CREATE TABLE app_info(
          key TEXT PRIMARY KEY,
          value INTEGER
        )
      ''');
    }
  }

  Future<void> insertUser(String email, String password) async {
    final db = await database;
    await db.insert('users', {'email': email, 'password': password});
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateUserOtp(String email, String otp) async {
    final db = await database;
    await db.update(
      'users',
      {'otp': otp},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> updatePassword(String email, String password) async {
    final db = await database;
    await db.update(
      'users',
      {'password': password, 'otp': null},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> saveRememberMe(String email, String password, bool rememberMe) async {
    final db = await database;
    await db.insert(
      'remember_me',
      {'email': email, 'password': password, 'remember_me': rememberMe ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> loadRememberMe() async {
    final db = await database;
    final result = await db.query('remember_me');
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> clearRememberMe() async {
    final db = await database;
    await db.delete('remember_me');
  }

  // Methods to manage the first-time flag
  Future<void> saveFirstTimeFlag(bool isFirstTime) async {
    final db = await database;
    await db.insert(
      'app_info',
      {'key': 'is_first_time', 'value': isFirstTime ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> isFirstTime() async {
    final db = await database;
    final result = await db.query(
      'app_info',
      where: 'key = ?',
      whereArgs: ['is_first_time'],
    );
    if (result.isNotEmpty) {
      return result.first['value'] == 1;
    }
    return true; // Default to true if not set
  }

  // Task-related methods
  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  Future<Map<String, dynamic>?> queryTaskByTitle(String title) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'value = ?',
      whereArgs: [title],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    await db.insert('tasks', task, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    final db = await database;
    await db.update(
      'tasks',
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}