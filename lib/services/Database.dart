import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:habit/objects/Habit.dart';

class DatabaseService {
  static final DatabaseService _singleton = new DatabaseService._internal();

  static final _databaseName = "habitus.db";
  static final _databaseVersion = 1;

  static Database _database;

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Habitos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            HabitoText VARCHAR(45) NOT NULL,
            RecompensaText VARCHAR(45) NOT NULL,
            DeixaText VARCHAR(45) NOT NULL,
            Categoria INTEGER NOT NULL,
            Pontuacao INTEGER NOT NULL
            );''');

    await db.execute('''
          CREATE TABLE Frequencia (
            Segunda BOOLEAN NOT NULL,
            Terca BOOLEAN NOT NULL,
            Quarta BOOLEAN NOT NULL,
            Quinta BOOLEAN NOT NULL,
            Sexta BOOLEAN NOT NULL,
            Sabado BOOLEAN NOT NULL,
            Domingo BOOLEAN NOT NULL,
            Habitos_id INTEGER NOT NULL UNIQUE,
            CONSTRAINT fk_Frequencia_Habitos
              FOREIGN KEY (Habitos_id)
              REFERENCES Habitos (id)
              ON DELETE NO ACTION
              ON UPDATE NO ACTION
           );''');

    await db.execute('''
          CREATE TABLE DiasFeito (
            Feito BOOLEAN NOT NULL,
            Dia DATETIME NOT NULL,
            Habitos_id INTEGER NOT NULL,
            CONSTRAINT fk_Frequencia_Habitos
              FOREIGN KEY (Habitos_id)
              REFERENCES Habitos (id)
              ON DELETE NO ACTION
              ON UPDATE NO ACTION
              );''');

    await db.execute('''
          CREATE TABLE Pessoa (
            Nome VARCHAR(45) NOT NULL,
            Pontuacao INTEGER NOT NULL);
          );''');
  }

  Future<List> getAllHabits() async {
    final db = await database;
    var result = await db.rawQuery('SELECT * FROM Habitos;');

    List<Habit> list = result.isNotEmpty ? result.map((c) => Habit.fromJson(c)).toList() : [];
    return list;
  }

  Future<Habit> getHabit(int id) async {
    final db = await database;
    var result = await db.rawQuery('SELECT * FROM Habitos WHERE id=$id;');

    if (result.isNotEmpty) {
      return Habit.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List> getHabitsToday() async {
    DateTime now = new DateTime.now();
    String weekday = "";
    switch (now.weekday) {
      case 1:
        weekday = "Segunda";
        break;
      case 2:
        weekday = "Terca";
        break;
      case 3:
        weekday = "Quarta";
        break;
      case 4:
        weekday = "Quinta";
        break;
      case 5:
        weekday = "Sexta";
        break;
      case 6:
        weekday = "Sabado";
        break;
      case 7:
        weekday = "Domingo";
        break;
    }

    final db = await database;
    var result = await db.rawQuery('''
        SELECT * FROM Habitos WHERE id IN (
        SELECT Habitos_id FROM Frequencia WHERE $weekday = 1 AND Habitos_id NOT IN (
        SELECT Habitos_id FROM DiasFeito WHERE Dia = \'${now.year.toString()}-${now.month.toString()}-${now.day.toString()}\'));''');

    List<Habit> list = result.isNotEmpty ? result.map((c) => Habit.fromJson(c)).toList() : [];
    return list;
  }

  Future<bool> habitDone(int id) async {
    DateTime now = new DateTime.now();
    final db = await database;
    await db.rawInsert(
        'INSERT INTO DiasFeito (Feito, Dia, Habitos_id) VALUES (1, \'${now.year.toString()}-${now.month.toString()}-${now.day.toString()}\', $id);');

    return true;
  }

  Future<bool> addHabit(Habit habit) async {
    final db = await database;
    var id = await db.rawInsert(
        'INSERT INTO Habitos (HabitoText, RecompensaText, DeixaText, Categoria, Pontuacao) VALUES (\'${habit.habit}\', \'${habit.reward}\', \'${habit.cue}\', ${habit.category}, ${habit.score});');
    await db.rawInsert(
        'INSERT INTO Frequencia (Segunda, Terca, Quarta, Quinta, Sexta, Sabado, Domingo, Habitos_id) VALUES (1, 1, 1, 1, 1, 1, 1, $id);');

    return true;
  }

//  Future<int> updateNote(Note note) async {
//    return await db.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}'
//    );
//  }
}
