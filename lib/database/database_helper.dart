import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {

    if (_database != null) return _database!;

    _database = await _initDB('gplx.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {

    await db.execute('''
    CREATE TABLE questions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      question TEXT,
      optionA TEXT,
      optionB TEXT,
      optionC TEXT,
      optionD TEXT,
      correctAnswer TEXT,
      topic TEXT,
      isCritical INTEGER
    )
    ''');

    await db.execute('''
    CREATE TABLE exam_results(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      score INTEGER,
      totalQuestions INTEGER,
      correct INTEGER,
      date TEXT
    )
    ''');
  }

  Future insertQuestion(Map<String, dynamic> row) async {

    final db = await instance.database;

    return await db.insert('questions', row);

  }

  Future<List<Map<String, dynamic>>> getQuestions() async {

    final db = await instance.database;

    return await db.query('questions');
  }


}