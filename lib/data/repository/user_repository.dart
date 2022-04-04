import 'package:altitude/common/constant/level_utils.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/model/pair.dart';
import 'package:altitude/infra/interface/i_score_service.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:altitude/infra/interface/i_fire_messaging.dart';
import 'package:injectable/injectable.dart';

abstract class IUserRepository {
  Future<Person> getUserData(bool fromServer);
  Future<void> updateFCMToken();
  Future<int> getReminderCounter();
  bool isLogged();
  Future<void> logout();
  Future<void> updateTotalScore(int score);
  Future<void> updateName(String name, List<String?> competitionsId);
  Future<void> updateLevel(int level);
  Future<void> recalculateScore();
  Future<void> createPerson(int? level, int? reminderCounter, int? score,
      List<String?>? friends, List<String?>? pendingFriends);
}

@Injectable(as: IUserRepository)
class UserRepository extends IUserRepository {
  final IFireMessaging _fireMessaging;
  final IFireDatabase _fireDatabase;
  final Memory _memory;
  final IFireAuth _fireAuth;
  final IScoreService _scoreService;

  UserRepository(this._memory, this._fireMessaging, this._fireDatabase,
      this._fireAuth, this._scoreService);

  @override
  Future<Person> getUserData(bool fromServer) async {
    if (_memory.person == null || fromServer) {
      var data = await _fireDatabase.getPerson();
      data.photoUrl = _fireAuth.getPhotoUrl() ?? "";
      _memory.person = data;

      if (data.fcmToken != await _fireMessaging.getToken) {
        updateFCMToken();
      }

      return data;
    } else {
      return Future.value(_memory.person);
    }
  }

  @override
  Future<void> updateFCMToken() async {
    List<String> competitionsId =
        await _fireDatabase.getCompetitions().then((list) {
      _memory.competitions = list;
      return list.map((e) => e.id ?? '').toList();
    });

    final token = await _fireMessaging.getToken;

    await _fireDatabase.updateFcmToken(token, competitionsId);
    _memory.person?.fcmToken = token;
  }

  @override
  Future<int> getReminderCounter() async {
    Person person = await getUserData(false);
    _memory.person?.reminderCounter += 1;
    return person.reminderCounter;
  }

  @override
  bool isLogged() {
    return _fireAuth.isLogged();
  }

  @override
  Future<void> logout() async {
    _memory.clear();
    await _fireAuth.logout();
  }

  @override
  Future<void> updateTotalScore(int score) {
    _memory.clear();
    return _fireDatabase.updateTotalScore(score, LevelUtils.getLevel(score));
  }

  @override
  Future<void> updateName(String name, List<String?> competitionsId) async {
    await _fireAuth.setName(name);
    await _fireDatabase.updateName(name, competitionsId);
    _memory.person?.name = name;
  }

  @override
  Future<void> updateLevel(int level) async {
    await _fireDatabase.updateLevel(level);
    _memory.person!.level = level;
  }

  @override
  Future<void> recalculateScore() async {
    int totalScore = 0;
    _memory.clear();

    List<Habit> habits = await _fireDatabase.getHabits();
    List<Competition> competitions = await _fireDatabase.getCompetitions();

    for (Habit habit in habits) {
      List<DayDone> daysDone = await _fireDatabase.getAllDaysDone(habit.id);

      int score = _scoreService.scoreEarnedTotal(
          habit.frequency!, daysDone.map((e) => e.date).toList());
      totalScore += score;

      List<Pair<String?, int>> competitionsScore = [];

      for (Competition competition in competitions
          .where((e) => e.getMyCompetitor().habitId == habit.id)
          .toList()) {
        int competitionScore = _scoreService.scoreEarnedTotal(
            habit.frequency!,
            daysDone
                .where((e) => e.date!.isAfterOrSameDay(competition.initialDate))
                .map((e) => e.date)
                .toList());

        competitionsScore.add(Pair(competition.id, competitionScore));
      }

      await _fireDatabase.updateHabitScore(habit.id, score, competitionsScore);
    }

    await _fireDatabase.updateTotalScore(
        totalScore, LevelUtils.getLevel(totalScore));

    _memory.clear();
  }

  @override
  Future<void> createPerson(int? level, int? reminderCounter, int? score,
      List<String?>? friends, List<String?>? pendingFriends) {
    return getUserData(true).then((date) {
      return updateFCMToken();
    }).catchError((error) async {
      Person person = Person(
          name: _fireAuth.getName(),
          email: _fireAuth.getEmail(),
          fcmToken: await _fireMessaging.getToken,
          level: level ?? 0,
          reminderCounter: reminderCounter ?? 0,
          score: score ?? 0,
          friends: friends ?? [],
          pendingFriends: pendingFriends ?? []);
      await _fireDatabase.createPerson(person);
      person.photoUrl = _fireAuth.getPhotoUrl();
      _memory.person = person;
    });
  }
}
