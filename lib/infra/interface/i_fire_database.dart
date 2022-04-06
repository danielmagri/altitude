import 'package:altitude/common/model/pair.dart';
import 'package:altitude/data/model/competition_model.dart';
import 'package:altitude/data/model/competitor_model.dart';
import 'package:altitude/data/model/day_done_model.dart';
import 'package:altitude/data/model/habit_model.dart';
import 'package:altitude/data/model/person_model.dart';
import 'package:altitude/data/model/reminder_model.dart';
import 'package:altitude/domain/models/frequency_entity.dart';
import 'package:altitude/domain/models/reminder_entity.dart';

abstract class IFireDatabase {
  Future<String> transferHabit(
    HabitModel habit,
    int? reminderCounter,
    List<String?> competitionsId,
    List<DayDoneModel> daysDone,
  );

  Future transferDayDonePlus(String habitId, List<DayDoneModel> daysDone);

  Future updateTotalScore(int? score, int level);

  Future updateHabitScore(
    String? habitId,
    int score,
    List<Pair<String?, int>> competitionsScore,
  );

  Future createPerson(PersonModel person);

  Future<PersonModel> getPerson();

  Future updateName(String name, List<String?> competitionsId);

  Future updateFcmToken(String? name, List<String?> competitionsId);

  Future updateLevel(int level);

  Future<HabitModel> addHabit(
    String habit,
    int colorCode,
    Frequency frequency,
    DateTime initialDate,
    Reminder? reminder,
    int? reminderCounter,
  );

  Future<List<HabitModel>> getHabits();

  Future<HabitModel> getHabit(String? id);

  Future updateHabit(
    HabitModel habit, [
    HabitModel? inititalHabit,
    List<String?>? competitionsId,
  ]);

  Future updateReminder(
    String? habitId,
    int? reminderCounter,
    ReminderModel? reminder,
  );

  Future completeHabit(
    String? habitId,
    bool isAdd,
    int score,
    bool isLastDone,
    DayDoneModel dayDone,
    List<String?> competitions,
  );

  Future deleteHabit(String? id);

  Future<List<DayDoneModel>> getAllDaysDone(String? id);

  Future<List<DayDoneModel>> getDaysDone(
    String? id,
    DateTime? startDate,
    DateTime endDate,
  );

  Future<bool> hasDoneAtDay(String? id, DateTime date);

  Future<List<PersonModel>> getFriendsDetails();

  Future<List<PersonModel>> getPendingFriends();

  Future<List<PersonModel>> getRankingFriends(int limit);

  Future<List<PersonModel>> searchEmail(
    String email,
    List<String?> myPendingFriends,
  );

  Future<String> friendRequest(String? uid);

  Future<String> acceptRequest(String? uid);

  Future declineRequest(String? uid);

  Future cancelFriendRequest(String? uid);

  Future removeFriend(String? uid);

  Future<List<CompetitionModel>> getCompetitions();

  Future<CompetitionModel> getCompetition(String? id);

  Future<List<CompetitionModel>> getPendingCompetitions();

  Future<CompetitionModel> createCompetition(
    String title,
    DateTime date,
    List<CompetitorModel> competitors,
    List<String> invitations,
  );

  Future updateCompetition(String? competitionId, String title);

  Future updateCompetitor(String competitionId, String habitId);

  Future inviteCompetitor(String? competitionId, List<String?> competitorId);

  Future removeCompetitor(String? competitionId, String uid, bool removeAll);

  Future acceptCompetitionRequest(
    String? competitionId,
    CompetitorModel competitor,
  );

  Future declineCompetitionRequest(String? competitionId);
}
