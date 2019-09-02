import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/objects/Reminder.dart';

class DatabaseService {
  static final DatabaseService _singleton = new DatabaseService._internal();

  static final _databaseName = "habitus.db";
  static final _databaseVersion = 4;

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
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.transaction((txn) async {
        await txn.execute('ALTER TABLE habit RENAME TO _habit_old;');
        await txn.execute('''
          CREATE TABLE habit (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            color INTEGER NOT NULL,
            score INTEGER NOT NULL DEFAULT 0,
            habit_text VARCHAR(30) NOT NULL,
            cue_text VARCHAR(45),
            initial_date DATE NOT NULL,
            days_done INTEGER NOT NULL DEFAULT 0);''');

        await txn.rawInsert(
            '''INSERT INTO habit(id, color, score, habit_text, cue_text, initial_date, days_done)
                               SELECT id, color, score, habit_text, cue_text, initial_date, days_done
                               FROM _habit_old;''');

        await txn.execute('DROP TABLE _habit_old;');
      });

      await db.transaction((txn) async {
        var result = await txn.rawQuery(
            'SELECT name FROM sqlite_master WHERE type=\'table\' AND name=\'freq_repeating\';');

        if (result != null && result.isNotEmpty) {
          await txn.rawInsert('''INSERT INTO freq_weekly(days_time, habit_id)
                               SELECT days_time, habit_id
                               FROM freq_repeating;''');

          await txn.execute('DROP TABLE freq_repeating;');
        }
      });

      await db.transaction((txn) async {
        await txn.execute('ALTER TABLE day_done RENAME TO _day_done_old;');
        await txn.execute('''
          CREATE TABLE day_done (
            date_done DATE NOT NULL,
            habit_id INTEGER NOT NULL,
            CONSTRAINT fk_day_done_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE CASCADE);''');

        await txn.rawInsert('''INSERT INTO day_done(date_done, habit_id)
                               SELECT date_done, habit_id
                               FROM _day_done_old;''');

        await txn.execute('DROP TABLE _day_done_old;');
      });
    }

    if (oldVersion < 4) {
      await db
          .execute('ALTER TABLE reminder ADD type INTEGER NOT NULL DEFAULT 0;');
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE habit (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            color INTEGER NOT NULL,
            score INTEGER NOT NULL DEFAULT 0,
            habit_text VARCHAR(30) NOT NULL,
            cue_text VARCHAR(45),
            initial_date DATE NOT NULL,
            days_done INTEGER NOT NULL DEFAULT 0);''');

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
              ON UPDATE CASCADE);''');

    await db.execute('''
          CREATE TABLE freq_weekly (
            days_time INTEGER NOT NULL,
            habit_id INTEGER NOT NULL UNIQUE,
            CONSTRAINT fk_freq_weekly_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE CASCADE);''');

    await db.execute('''
          CREATE TABLE day_done (
            date_done DATE NOT NULL,
            habit_id INTEGER NOT NULL,
            CONSTRAINT fk_day_done_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE CASCADE);''');

    await db.execute('''
          CREATE TABLE reminder (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            type INTEGER NOT NULL DEFAULT 0,
            hour INTEGER NOT NULL,
            minute INTEGER NOT NULL,
            weekday INTEGER NOT NULL,
            habit_id INTEGER NOT NULL,
            CONSTRAINT fk_reminder_habit_id
              FOREIGN KEY (habit_id)
              REFERENCES habit(id)
              ON DELETE CASCADE
              ON UPDATE CASCADE);''');
  }

  /// Retorna a quantidade de hábitos registrados.
  Future<int> getAllHabitsCount() async {
    final db = await database;
    var result = await db.rawQuery('SELECT COUNT(*) as qtd FROM habit;');

    int qtd = result.first["qtd"] != null ? result.first["qtd"] : 0;
    return qtd;
  }

  /// Retorna todos os hábitos registrados.
  Future<List> getAllHabits() async {
    final db = await database;
    var result = await db.rawQuery('SELECT id, color, habit_text FROM habit;');

    List<Habit> list =
        result.isNotEmpty ? result.map((c) => Habit.fromJson(c)).toList() : [];
    return list;
  }

  /// Retorna os dados de um hábito específico.
  Future<Habit> getHabit(int id) async {
    final db = await database;

    var result = await db.rawQuery('SELECT * FROM habit WHERE id=$id;');

    return result.isNotEmpty ? Habit.fromJson(result.first) : null;
  }

  /// Retorna os hábitos para serem feitos hoje.
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
        SELECT id, color, habit_text FROM habit WHERE id IN (
							 SELECT habit_id FROM freq_day_week WHERE $weekday=1 
							 UNION ALL
               SELECT habit_id FROM freq_weekly WHERE habit_id NOT IN (SELECT habit_id FROM day_done WHERE date_done>\'${startWeek.year}-${startWeek.month.toString().padLeft(2, '0')}-${startWeek.day.toString().padLeft(2, '0')}\' AND date_done!=\'${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\' GROUP BY habit_id HAVING COUNT(*) >= days_time)
               );''');

    List<Habit> list =
        result.isNotEmpty ? result.map((c) => Habit.fromJson(c)).toList() : [];
    return list;
  }

  /// Retorna os hábitos feitos hoje.
  Future<List> getHabitsDoneToday() async {
    DateTime now = new DateTime.now();

    final db = await database;
    var result = await db.rawQuery(
        'SELECT habit_id FROM day_done WHERE date_done=\'${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\';');

    List<DayDone> list = result.isNotEmpty
        ? result.map((c) => DayDone.fromJson(c)).toList()
        : [];
    return list;
  }

  /// Retorna a lista de alarmes do hábito.
  Future<List<Reminder>> getReminders(int id) async {
    final db = await database;

    var result =
        await db.rawQuery('SELECT * FROM reminder WHERE habit_id=$id;');

    List<Reminder> list = result.isNotEmpty
        ? result.map((c) => Reminder.fromJson(c)).toList()
        : [];
    return list;
  }

  /// Retorna a frequência do hábito.
  Future<dynamic> getFrequency(int id) async {
    final db = await database;

    var resultDayWeek =
        await db.rawQuery('SELECT * FROM freq_day_week WHERE habit_id=$id;');

    var resultWeekly =
        await db.rawQuery('SELECT * FROM freq_weekly WHERE habit_id=$id;');

    if (resultDayWeek.isNotEmpty) {
      return FreqDayWeek.fromJson(resultDayWeek.first);
    } else if (resultWeekly.isNotEmpty) {
      return FreqWeekly.fromJson(resultWeekly.first);
    } else {
      return null;
    }
  }

  /// Retorna uma lista com os dias feitos do hábito.
  Future<List<DayDone>> getDaysDone(int id,
      {DateTime startDate, DateTime endDate}) async {
    final db = await database;
    List<dynamic> result;

    if (startDate != null && endDate != null) {
      result = await db.rawQuery('''SELECT * FROM day_done WHERE habit_id=$id
                                                                 AND date_done>=\'${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}\'
                                                                 AND date_done<=\'${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}\'
                                                                 ORDER BY date_done;''');
    } else if (startDate != null && endDate == null) {
      result = await db.rawQuery('''SELECT * FROM day_done WHERE habit_id=$id
                                                                 AND date_done>=\'${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}\'
                                                                 ORDER BY date_done;''');
    } else if (startDate == null && endDate != null) {
      result = await db.rawQuery('''SELECT * FROM day_done WHERE habit_id=$id
                                                                 AND date_done<=\'${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}\'
                                                                 ORDER BY date_done;''');
    } else {
      result = await db.rawQuery(
          'SELECT * FROM day_done WHERE habit_id=$id ORDER BY date_done;');
    }

    List<DayDone> list = result.isNotEmpty
        ? result.map((c) => DayDone.fromJson(c)).toList()
        : [];
    return list;
  }

  /// Registra o dia feito do hábito.
  Future<bool> setDayDone(int id, DateTime date) async {
    final db = await database;
    await db.rawInsert(
        '''INSERT INTO day_done (date_done, habit_id) VALUES (\'${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}\',
                                                                                   $id);''');

    await db.rawInsert('UPDATE habit SET days_done=days_done+1 WHERE id=$id;');

    return true;
  }

  /// Atualiza a pontuação do hábito.
  Future<bool> updateScore(int id, int score) async {
    final db = await database;

    await db.rawInsert('UPDATE habit SET score = score+$score WHERE id=$id;');

    return true;
  }

  /// Adiciona um novo hábito com sua frequência e alarmes.
  Future<Map> addHabit(
      Habit habit, dynamic frequency, List<Reminder> reminders) async {
    DateTime now = new DateTime.now();
    final db = await database;

    // Inserção dos dados do hábito
    var id = await db.rawInsert(
        '''INSERT INTO habit (habit_text, color, initial_date) VALUES (\'${habit.habit}\',
                                                                                        ${habit.color},
                                                                                        \'${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}\');''');
    // Inserção dos dados da frequência
    await addFrequency(id, frequency);

    // Inserção dos dados dos alarmes
    List<Reminder> remindersAdded = await addReminders(id, reminders);

    return {0: id, 1: remindersAdded};
  }

  /// Adiciona os alarmes do hábito.
  Future<List<Reminder>> addReminders(
      int habitId, List<Reminder> reminders) async {
    final db = await database;
    List<Reminder> remindersAdded = new List();

    for (Reminder reminder in reminders) {
      int reminderId = await db.rawInsert(
          '''INSERT INTO reminder (hour, minute, weekday, type, habit_id) VALUES (${reminder.hour},
                                                                                  ${reminder.minute},
                                                                                  ${reminder.weekday},
                                                                                  ${reminder.type},
                                                                                  $habitId);''');
      remindersAdded.add(new Reminder(
          id: reminderId,
          hour: reminder.hour,
          minute: reminder.minute,
          type: reminder.type,
          habitId: reminder.habitId,
          weekday: reminder.weekday));
    }

    return remindersAdded;
  }

  /// Adiciona a frequência do hábito.
  Future<bool> addFrequency(int id, dynamic frequency) async {
    final db = await database;

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
      await db.rawInsert(
          'INSERT INTO freq_weekly (days_time, habit_id) VALUES (${freq.daysTime}, $id);');
    }

    return true;
  }

  /// Atualiza o hábito.
  Future<bool> updateHabit(Habit habit) async {
    final db = await database;

    await db.rawUpdate('''UPDATE habit SET habit_text=\'${habit.habit}\',
                                           color=${habit.color} 
                                           WHERE id=${habit.id};''');

    return true;
  }

  /// Atualiza o gatilho do hábito.
  Future<bool> updateCue(int id, String cue) async {
    final db = await database;
    String cueText;

    if (cue != null) {
      cueText = "\'$cue\'";
    }

    await db.rawUpdate('''UPDATE habit SET cue_text=$cueText
                                           WHERE id=$id;''');

    return true;
  }

  /// Atualiza a frequência do hábito.
  Future<bool> updateFrequency(
      int id, dynamic frequency, Type typeOldFreq) async {
    final db = await database;

    if (frequency.runtimeType == typeOldFreq) {
      switch (frequency.runtimeType) {
        case FreqDayWeek:
          FreqDayWeek freq = frequency;
          await db.rawUpdate('''UPDATE freq_day_week SET monday=${freq.monday},
                                                       tuesday=${freq.tuesday},
                                                       wednesday=${freq.wednesday},
                                                       thursday=${freq.thursday},
                                                       friday=${freq.friday},
                                                       saturday=${freq.saturday},
                                                       sunday=${freq.sunday} WHERE habit_id=$id;''');
          break;
        case FreqWeekly:
          FreqWeekly freq = frequency;
          await db.rawUpdate(
              '''UPDATE freq_weekly SET days_time=${freq.daysTime} WHERE habit_id=$id;''');
          break;
      }
    } else {
      switch (typeOldFreq) {
        case FreqDayWeek:
          await db
              .rawDelete('''DELETE FROM freq_day_week WHERE habit_id=$id;''');
          break;
        case FreqWeekly:
          await db.rawDelete('''DELETE FROM freq_weekly WHERE habit_id=$id;''');
          break;
      }

      await addFrequency(id, frequency);
    }

    return true;
  }

  /// Deleta o hábito.
  Future<bool> deleteHabit(int id) async {
    final db = await database;

    await db.rawDelete('''DELETE FROM habit WHERE id=$id;''');

    return true;
  }

  /// Deleta os alarmes do hábito.
  Future<bool> deleteAllReminders(int habitId) async {
    final db = await database;

    await db.rawDelete('''DELETE FROM reminder WHERE habit_id=$habitId;''');

    return true;
  }

  /// Deleta o dia feito do hábito.
  Future<bool> deleteDayDone(int id, DateTime date) async {
    final db = await database;

    await db.rawDelete(
        '''DELETE FROM day_done WHERE date_done=\'${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}\'
                                                     AND habit_id=$id;''');

    await db.rawInsert('UPDATE habit SET days_done=days_done-1 WHERE id=$id;');

    return true;
  }
}
