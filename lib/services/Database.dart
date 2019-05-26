import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:habit/objects/Person.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/objects/DayDone.dart';

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
          CREATE TABLE person (
            full_name VARCHAR(45) NOT NULL,
            score INTEGER NOT NULL);''');

    await db.execute('''
          CREATE TABLE habit (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            category INTEGER NOT NULL,
            icon INTEGER NOT NULL,
            score INTEGER NOT NULL,
            cycle INTEGER NOT NULL,
            habit_text VARCHAR(45) NOT NULL,
            reward_text VARCHAR(45) NOT NULL,
            cue_text VARCHAR(45) NOT NULL,
            initial_date DATE NOT NULL,
            days_done INTEGER NOT NULL);''');

    await db.execute('''
          CREATE TABLE freq_day_week (
            monday TINYINT NOT NULL,
            tuesday TINYINT NOT NULL,
            wednesday TINYINT NOT NULL,
            thursday TINYINT NOT NULL,
            friday TINYINT NOT NULL,
            saturday TINYINT NOT NULL,
            sunday TINYINT NOT NULL,
            habit_id INTEGER NOT NULL UNIQUE,
            CONSTRAINT fk_freq_day_week_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION);''');

    await db.execute('''
          CREATE TABLE freq_weekly (
            days_time INTEGER NOT NULL,
            habit_id INTEGER NOT NULL UNIQUE,
            CONSTRAINT fk_freq_weekly_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION);''');

    await db.execute('''
          CREATE TABLE freq_repeating (
            days_time INTEGER NOT NULL,
            days_cycle INTEGER NOT NULL,
            habit_id INTEGER NOT NULL UNIQUE,
            CONSTRAINT fk_freq_repeating_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION);''');

    await db.execute('''
          CREATE TABLE progress (
            type INTEGER NOT NULL,
            progress REAL,
            unit VARCHAR(45),
            goal INTEGER,
            habit_id INTEGER NOT NULL,
            CONSTRAINT fk_progress_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION);''');

    await db.execute('''
          CREATE TABLE day_done (
            done TINYINT NOT NULL,
            cycle INTEGER NOT NULL,
            date_done DATE NOT NULL,
            habit_id INTEGER NOT NULL,
            CONSTRAINT fk_day_done_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE NO ACTION);''');
  }

  Future<Person> getPerson() async {
    final db = await database;

    var result = await db.rawQuery('SELECT * FROM person;');

    if (result.isNotEmpty) {
      return Person.fromJson(result.first);
    } else {
      await db.rawInsert('INSERT INTO person (full_name, score) VALUES (\'Teste\', 0);');
      return Person(name: "Teste", score: 0);
    }
  }

  Future<List> getAllHabits() async {
    final db = await database;
    var result = await db.rawQuery('SELECT id, category, habit_text, icon FROM habit;');

    List<Habit> list = result.isNotEmpty ? result.map((c) => Habit.fromJson(c)).toList() : [];
    return list;
  }

  Future<Habit> getHabit(int id) async {
    final db = await database;

    var result = await db.rawQuery('SELECT * FROM habit AS h, progress AS p WHERE h.id=$id AND p.habit_id=h.id;');

    if (result.isNotEmpty) {
      return Habit.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List> getHabitsToday() async {
    DateTime now = new DateTime.now();
    DateTime startWeek;
    String weekday = "";
    switch (now.weekday) {
      case 1:
        weekday = "monday";
        startWeek = now.subtract(Duration(days: 1));
        break;
      case 2:
        weekday = "tuesday";
        startWeek = now.subtract(Duration(days: 2));
        break;
      case 3:
        weekday = "wednesday";
        startWeek = now.subtract(Duration(days: 3));
        break;
      case 4:
        weekday = "thursday";
        startWeek = now.subtract(Duration(days: 4));
        break;
      case 5:
        weekday = "friday";
        startWeek = now.subtract(Duration(days: 5));
        break;
      case 6:
        weekday = "saturday";
        startWeek = now.subtract(Duration(days: 6));
        break;
      case 7:
        weekday = "sunday";
        startWeek = now;
        break;
    }

    final db = await database;

    var result = await db.rawQuery('''
        SELECT h.id, h.category, h.habit_text, h.cycle, h.icon, p.* FROM habit AS h, progress AS p WHERE p.habit_id=h.id AND h.id IN (
							 SELECT habit_id FROM freq_day_week WHERE $weekday=1 AND habit_id NOT IN (SELECT habit_id FROM day_done WHERE date_done=\'${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\')
							 UNION ALL
               SELECT habit_id FROM freq_weekly WHERE habit_id NOT IN (SELECT habit_id FROM day_done WHERE date_done>\'${startWeek.year}-${startWeek.month.toString().padLeft(2, '0')}-${startWeek.day.toString().padLeft(2, '0')}\' GROUP BY habit_id HAVING COUNT(*) >= days_time
							                            														 UNION ALL SELECT habit_id FROM day_done WHERE date_done=\'${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\')
               UNION ALL
               SELECT habit_id FROM freq_repeating WHERE habit_id NOT IN (SELECT habit_id FROM day_done WHERE date_done>DATE('now', '-days_cicle day') GROUP BY habit_id HAVING COUNT(*) >= days_time
							                              															UNION ALL SELECT habit_id FROM day_done WHERE date_done=\'${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\')
        );''');

    List<Habit> list = result.isNotEmpty ? result.map((c) => Habit.fromJson(c)).toList() : [];
    return list;
  }

  Future<dynamic> getFrequency(int id) async {
    final db = await database;

    var resultDayWeek = await db.rawQuery('SELECT * FROM freq_day_week WHERE habit_id=$id;');

    var resultWeekly = await db.rawQuery('SELECT * FROM freq_weekly WHERE habit_id=$id;');

    var resultRepeating = await db.rawQuery('SELECT * FROM freq_repeating WHERE habit_id=$id;');

    if (resultDayWeek.isNotEmpty) {
      return FreqDayWeek.fromJson(resultDayWeek.first);
    } else if (resultWeekly.isNotEmpty) {
      return FreqWeekly.fromJson(resultWeekly.first);
    } else if (resultRepeating.isNotEmpty) {
      return FreqRepeating.fromJson(resultRepeating.first);
    } else {
      return null;
    }
  }

  Future<List> getDaysDone(int id) async {
    final db = await database;

    var result = await db.rawQuery('SELECT * FROM day_done WHERE habit_id=$id;');

    List<DayDone> list = result.isNotEmpty ? result.map((c) => DayDone.fromJson(c)).toList() : [];
    return list;
  }

  Future<List> getCycleDaysDone(int id, int cycle) async {
    final db = await database;

    var result = await db.rawQuery('''SELECT date_done FROM day_done WHERE habit_id=$id AND cycle=$cycle;''');

    List<DayDone> list = result.isNotEmpty ? result.map((c) => DayDone.fromJson(c)).toList() : [];
    return list;
  }

  Future<bool> habitDone(int id, int cycle, bool changeCycle) async {
    DateTime now = new DateTime.now();
    int numCycle = changeCycle ? cycle + 1 : cycle;

    final db = await database;
    await db.rawInsert('''INSERT INTO day_done (done, cycle, date_done, habit_id) VALUES (1,
                                                                           $numCycle,
                                                                           \'${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\',
                                                                           $id);''');

    await db.rawInsert('UPDATE habit SET days_done=days_done+1, cycle=$numCycle WHERE id=$id;');

    return true;
  }

  Future<bool> updateScore(int id, int score) async {
    final db = await database;

    await db.rawInsert('UPDATE habit SET score = score+$score WHERE id=$id;');
    await db.rawInsert('UPDATE person SET score = score+$score;');

    return true;
  }

  Future<bool> updateProgress(int id, double progress) async {
    final db = await database;

    await db.rawInsert('UPDATE progress SET progress=$progress WHERE habit_id=$id;');

    return true;
  }

  Future<bool> addHabit(Habit habit, dynamic frequency) async {
    DateTime now = new DateTime.now();
    final db = await database;
    var id = await db.rawInsert(
        '''INSERT INTO habit (habit_text, reward_text, cue_text, category, icon, score, cycle, initial_date, days_done) VALUES (\'${habit.habit}\',
                                                                                                                   \'${habit.reward}\',
                                                                                                                   \'${habit.cue}\',
                                                                                                                   ${habit.category.index},
                                                                                                                   ${habit.icon},
                                                                                                                   0,
                                                                                                                   1,
                                                                                                                   \'${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\',
                                                                                                                   0);''');

    await db.rawInsert('''INSERT INTO progress (type, progress, unit, goal, habit_id) VALUES (${habit.progress.type.index},
                                                                         ${habit.progress.progress},
                                                                         \'${habit.progress.unit}\',
                                                                         ${habit.progress.goal},
                                                                         $id);''');

    if (frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freq = frequency;
      await db.rawInsert(
          '''INSERT INTO freq_day_week (monday, tuesday, wednesday, thursday, friday, saturday, sunday, habit_id) VALUES (${freq.monday},
                                                                                                                          ${freq.tuesday},
                                                                                                                          ${freq.wednesday},
                                                                                                                          ${freq.thursday},
                                                                                                                          ${freq.friday},
                                                                                                                          ${freq.saturday},
                                                                                                                          ${freq.sunday},
                                                                                                                            $id);''');
    } else if (frequency.runtimeType == FreqWeekly) {
      FreqWeekly freq = frequency;
      await db.rawInsert('INSERT INTO freq_weekly (days_time, habit_id) VALUES (${freq.daysTime}, $id);');
    } else if (frequency.runtimeType == FreqRepeating) {
      FreqRepeating freq = frequency;
      await db.rawInsert('''INSERT INTO freq_repeating (days_time, days_cycle, habit_id) VALUES (${freq.daysTime},
                                                                                                   ${freq.daysCycle},
                                                                                                   $id);''');
    }

    return true;
  }

  Future<bool> updateHabit(Habit habit) async {
    final db = await database;

    await db.rawInsert('''UPDATE habit SET habit_text=\'${habit.habit}\',
                                           reward_text=\'${habit.reward}\',
                                           cue_text=\'${habit.cue}\',
                                           category=${habit.category.index}  WHERE id=${habit.id};''');

    return true;
  }

  Future<bool> deleteHabit(int id) async {
    final db = await database;

    await db.rawInsert('''DELETE FROM habit WHERE id=$id;''');

    return true;
  }
}
