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

    // Xóa database cũ mỗi lần chạy app
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createData,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _createData(Database db, int version) async {
    await _createDB(db);
    await _insertTopics(db);
    await _insertQuestions(db);
  }

  Future _createDB(Database db) async {
      // TABLE: topics
      await db.execute('''
      CREATE TABLE topics(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        fullname TEXT NOT NULL,
        description TEXT
      )
      ''');
      // TABLE: questions
      await db.execute('''
      CREATE TABLE questions(
        id INTEGER PRIMARY KEY,
        topic_id INTEGER,
        question TEXT NOT NULL,
        image_url TEXT,
        answer_a TEXT,
        answer_b TEXT,
        answer_c TEXT,
        answer_d TEXT,
        ofRankA INTEGER DEFAULT 0,
        ofRankB INTEGER DEFAULT 0,
        correct_answer TEXT NOT NULL,  
        explanation TEXT, 
        is_critical INTEGER DEFAULT 0,
        FOREIGN KEY(topic_id) REFERENCES topics(id)
      )
      ''');

      // TABLE: ranks
      await db.execute('''
      CREATE TABLE ranks(
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT
      )
      ''');

      // TABLE: practice_sessions
      await db.execute('''
      CREATE TABLE practice_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
    
        mode TEXT,
    
        topic_id INTEGER,
    
        total_questions INTEGER,
    
        correct_answers INTEGER,
    
        score INTEGER,
    
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
        FOREIGN KEY(topic_id) REFERENCES topics(id)
      )
      ''');

      // TABLE: user_answers
      await db.execute('''
      CREATE TABLE user_answers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
    
        session_id INTEGER,
    
        question_id INTEGER,
    
        selected_answer TEXT,
    
        is_correct INTEGER,
    
        FOREIGN KEY(session_id) REFERENCES practice_sessions(id),
    
        FOREIGN KEY(question_id) REFERENCES questions(id)
      )
      ''');

      // TABLE: wrong_questions
      await db.execute('''
      CREATE TABLE wrong_questions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
    
        question_id INTEGER UNIQUE,
    
        wrong_count INTEGER DEFAULT 1,
    
        last_wrong_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
        FOREIGN KEY(question_id) REFERENCES questions(id)
      )
      ''');

      // TABLE: exam_history
      await db.execute('''
      CREATE TABLE exam_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
    
        license_type TEXT,
    
        total_questions INTEGER,
    
        correct_answers INTEGER,
    
        is_passed INTEGER,
    
        time_spent INTEGER,
    
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
      ''');
  }

  Future _insertTopics(Database db) async {
    List<Map<String, dynamic>> topics = [
      {
        'id': 1,
        'name': 'Khái niệm và quy tắc',
        'fullname': 'Chương I. Quy định chung và quy tắc giao thông đường bộ:',
        'description': ' 180 câu (từ câu số 1 đến câu 180).'
      },
      {
        'id': 2,
        'name': 'Văn hóa đạo đức',
        'fullname': 'Chương II. Văn hóa giao thông, đạo đức người lái xe, kỹ năng phòng cháy, chữa cháy và cứu hộ, cứu nạn',
        'description': '25 câu (từ câu 181 đến câu 205).'
      },
      {
        'id': 3,
        'name': 'Kỹ thuật lái xe',
        'fullname': 'Chương III. Kỹ thuật lái xe',
        'description': '58 câu (từ câu 206 đến câu 263).'
      },
      {
        'id': 4,
        'name': 'Cấu tạo và sửa chữa',
        'fullname': 'Chương IV. Cấu tạo và sửa chữa',
        'description': '37 câu (từ câu 264 đến câu 300).'
      },
      {
        'id': 5,
        'name': 'Biển báo đường bộ',
        'fullname': 'Chương V. Báo hiệu đường bộ',
        'description': '185 câu (từ câu 301 đến câu 485).'
      },
      {
        'id': 6,
        'name': 'Sa hình',
        'fullname': 'Chương VI. Giải thế sa hình và kỹ năng xử lý tình huống giao thông',
        'description': '115 câu (từ câu 486 đến câu 600).'
      }
    ];
    for (var topic in topics) {
      await db.insert('topics', topic);
    }
  }

  Future _insertQuestions(Database db) async {
    List<Map<String, dynamic>> questions = [
      {
        'id': 451,
        'topic_id': 5,
        'question': 'Biển nào chỉ dẫn cho người đi bộ sử dụng hầm chui qua đường?',
        'image_url': 'assets/images/questions/c451.png',
        'answer_a': 'Biển 1.',
        'answer_b': 'Biển 2.',
        'answer_c': 'Cả hai biển.',
        'answer_d': 'Không biển nào.',
        'ofRankA': 1,
        'ofRankB': 1,
        'correct_answer': 'B',
        'explanation': 'Biển 1: I424b “Cầu vượt qua đường cho người đi bộ”; Biển 2: I424d “Hầm chui qua đường cho người đi bộ” nên đáp án đúng là biển 2.'
      },
      {
        'id': 452,
        'topic_id': 5,
        'question': 'Biển nào báo hiệu "Nơi đỗ xe dành cho người khuyết tật"?',
        'image_url': 'assets/images/questions/c452.png',
        'answer_a': 'Biển 1.',
        'answer_b': 'Biển 2.',
        'answer_c': 'Biển 3.',
        'correct_answer': 'B',
        'ofRankA': 1,
        'ofRankB': 1,
        'explanation': ' Biển 1: R.304 “Đường dành cho xe thô sơ”; Biển 2: I.446 “Nơi đỗ xe dành cho người khuyết tật”; Biển 3: R.305 “Đường dành cho người đi bộ”'
      },

    ];

    for (var q in questions) {
      await db.insert('questions', q);
    }
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