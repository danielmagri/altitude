import 'package:altitude/common/constant/constants.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/common/model/pair.dart';
import 'package:altitude/data/model/competition_model.dart';
import 'package:altitude/data/model/competitor_model.dart';
import 'package:altitude/data/model/day_done_model.dart';
import 'package:altitude/data/model/habit_model.dart';
import 'package:altitude/data/model/person_model.dart';
import 'package:altitude/data/model/reminder_model.dart';
import 'package:altitude/domain/models/frequency_entity.dart';
import 'package:altitude/domain/models/reminder_entity.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IFireDatabase)
class FireDatabase implements IFireDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const _users = 'users';
  static const _habits = 'habits';
  static const _competitions = 'competitions';
  static const _daysDone = 'days_done';

  CollectionReference get userCollection => firestore.collection(_users);
  DocumentReference get userDoc =>
      userCollection.doc(GetIt.I.get<IFireAuth>().getUid());
  CollectionReference get habitsCollection => userDoc.collection(_habits);
  CollectionReference get competitionCollection =>
      firestore.collection(_competitions);

  // TRANSFER DATA

  @override
  Future<String> transferHabit(
    HabitModel habit,
    int? reminderCounter,
    List<String?> competitionsId,
    List<DayDoneModel> daysDone,
  ) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = habitsCollection.doc();
    habit.id = doc.id;
    batch.set(doc, habit.toJson());
    if (reminderCounter != null) {
      batch.update(userDoc, {PersonModel.reminderCounterTag: reminderCounter});
    }

    for (String? competitionId in competitionsId) {
      batch.set(
        competitionCollection.doc(competitionId),
        {
          CompetitionModel.competitorsTag: {
            GetIt.I.get<IFireAuth>().getUid(): {
              CompetitorModel.habitIdTag: habit.id
            }
          }
        },
        SetOptions(merge: true),
      );
    }

    CollectionReference daysDoneCollection = doc.collection(_daysDone);
    for (DayDoneModel dayDone in daysDone) {
      batch.set(
        daysDoneCollection.doc(dayDone.dateFormatted),
        dayDone.toJson(),
      );
    }

    return batch.commit().then((value) => doc.id);
  }

  @override
  Future transferDayDonePlus(String habitId, List<DayDoneModel> daysDone) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection(_daysDone);
    for (DayDoneModel dayDone in daysDone) {
      batch.set(
        daysDoneCollection.doc(dayDone.dateFormatted),
        dayDone.toJson(),
      );
    }

    return batch.commit();
  }

  @override
  Future updateTotalScore(int? score, int level) {
    return userDoc
        .update({PersonModel.scoreTag: score, PersonModel.levelTag: level});
  }

  @override
  Future updateHabitScore(
    String? habitId,
    int score,
    List<Pair<String?, int>> competitionsScore,
  ) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference habitDoc = habitsCollection.doc(habitId);

    batch.update(habitDoc, {HabitModel.scoreTag: score});

    for (Pair<String?, int> item in competitionsScore) {
      batch.set(
        competitionCollection.doc(item.first),
        {
          CompetitionModel.competitorsTag: {
            GetIt.I.get<IFireAuth>().getUid(): {
              CompetitorModel.scoreTag: item.second
            }
          }
        },
        SetOptions(merge: true),
      );
    }

    return batch.commit();
  }

  // PERSON

  @override
  Future createPerson(PersonModel person) {
    return userDoc.set(person.toJson(), SetOptions(merge: true));
  }

  @override
  Future<PersonModel> getPerson() {
    return userDoc.get().then(
          (value) => PersonModel.fromJson(
            value.data() as Map<String, dynamic>,
            value.id,
          ),
        );
  }

  @override
  Future updateName(String name, List<String?> competitionsId) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    userDoc.update({PersonModel.nameTag: name});

    if (competitionsId != null) {
      for (String? item in competitionsId) {
        batch.set(
          competitionCollection.doc(item),
          {
            CompetitionModel.competitorsTag: {
              GetIt.I.get<IFireAuth>().getUid(): {CompetitorModel.nameTag: name}
            }
          },
          SetOptions(merge: true),
        );
      }
    }

    return batch.commit();
  }

  @override
  Future updateFcmToken(String? token, List<String?> competitionsId) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    userDoc.update({PersonModel.fcmTokenTag: token});

    if (competitionsId != null) {
      for (String? item in competitionsId) {
        batch.set(
          competitionCollection.doc(item),
          {
            CompetitionModel.competitorsTag: {
              GetIt.I.get<IFireAuth>().getUid(): {
                CompetitorModel.fcmTokenTag: token
              }
            }
          },
          SetOptions(merge: true),
        );
      }
    }

    return batch.commit();
  }

  @override
  Future updateLevel(int level) {
    return userDoc.update({PersonModel.levelTag: level});
  }

  // HABIT

  @override
  Future<HabitModel> addHabit(
    String habit,
    int colorCode,
    Frequency frequency,
    DateTime initialDate,
    Reminder? reminder,
    int? reminderCounter,
  ) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference doc = habitsCollection.doc();

    var habitModel = HabitModel(
        id: doc.id,
        habit: habit,
        colorCode: colorCode,
        frequency: frequency,
        initialDate: initialDate);

    batch.set(doc, habitModel.toJson());
    if (reminderCounter != null) {
      batch.update(userDoc, {PersonModel.reminderCounterTag: reminderCounter});
    }
    return batch.commit().then((value) => habitModel);
  }

  @override
  Future<List<HabitModel>> getHabits() {
    return habitsCollection.get().then(
          (value) => value.docs
              .map((e) => HabitModel.fromJson(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Future<HabitModel> getHabit(String? id) {
    return habitsCollection.doc(id).get().then(
          (value) => HabitModel.fromJson(value.data() as Map<String, dynamic>),
        );
  }

  @override
  Future updateHabit(
    HabitModel habit, [
    HabitModel? inititalHabit,
    List<String?>? competitionsId,
  ]) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    if (inititalHabit != null &&
        competitionsId != null &&
        habit.colorCode != inititalHabit.colorCode) {
      for (String? item in competitionsId) {
        batch.set(
          competitionCollection.doc(item),
          {
            CompetitionModel.competitorsTag: {
              GetIt.I.get<IFireAuth>().getUid(): {
                CompetitorModel.colorTag: habit.colorCode
              }
            }
          },
          SetOptions(merge: true),
        );
      }
    }

    batch.update(habitsCollection.doc(habit.id), habit.toJson());

    return batch.commit();
  }

  @override
  Future updateReminder(
    String? habitId,
    int? reminderCounter,
    ReminderModel? reminder,
  ) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      habitsCollection.doc(habitId),
      {HabitModel.reminderTag: reminder?.toJson()},
    );
    if (reminderCounter != null) {
      batch.update(userDoc, {PersonModel.reminderCounterTag: reminderCounter});
    }

    return batch.commit();
  }

  @override
  Future completeHabit(
    String? habitId,
    bool isAdd,
    int score,
    bool isLastDone,
    DayDoneModel dayDone,
    List<String?> competitions,
  ) {
    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection(_daysDone);

    return daysDoneCollection.doc(dayDone.dateFormatted).get().then((date) {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      if (competitions != null) {
        for (String? item in competitions) {
          batch.set(
            competitionCollection.doc(item),
            {
              CompetitionModel.competitorsTag: {
                GetIt.I.get<IFireAuth>().getUid(): {
                  CompetitorModel.scoreTag: FieldValue.increment(score)
                }
              }
            },
            SetOptions(merge: true),
          );
        }
      }

      Map<String, dynamic> habitMap = {};
      habitMap.putIfAbsent(
        HabitModel.scoreTag,
        () => FieldValue.increment(score),
      );
      habitMap.putIfAbsent(
        HabitModel.daysDoneCountTag,
        () => FieldValue.increment(isAdd ? 1 : -1),
      );

      if (!date.exists && isAdd) {
        if (isLastDone) {
          habitMap.putIfAbsent(HabitModel.lastDoneTag, () => dayDone.date);
        }
        batch.set(
          daysDoneCollection.doc(dayDone.dateFormatted),
          dayDone.toJson(),
        );
      } else if (date.exists && !isAdd) {
        if (isLastDone)
          habitMap.putIfAbsent(HabitModel.lastDoneTag, () => null);
        batch.delete(daysDoneCollection.doc(dayDone.dateFormatted));
      } else {
        if (date.exists && isAdd) {
          throw 'Você já completou esse dia';
        }
        throw 'Erro desconhecido';
      }

      batch
          .update(userDoc, {PersonModel.scoreTag: FieldValue.increment(score)});
      batch.update(habitDoc, habitMap);

      return batch.commit();
    });
  }

  @override
  Future deleteHabit(String? id) {
    return habitsCollection.doc(id).delete();
  }

  // DAYS DONE

  @override
  Future<List<DayDoneModel>> getAllDaysDone(String? id) {
    return habitsCollection.doc(id).collection(_daysDone).get().then(
          (value) =>
              value.docs.map((e) => DayDoneModel.fromJson(e.data())).toList(),
        );
  }

  @override
  Future<List<DayDoneModel>> getDaysDone(
    String? id,
    DateTime? startDate,
    DateTime endDate,
  ) {
    return habitsCollection
        .doc(id)
        .collection(_daysDone)
        .where(DayDoneModel.dateTag, isGreaterThanOrEqualTo: startDate)
        .where(DayDoneModel.dateTag, isLessThanOrEqualTo: endDate)
        .get()
        .then(
          (value) =>
              value.docs.map((e) => DayDoneModel.fromJson(e.data())).toList(),
        );
  }

  @override
  Future<bool> hasDoneAtDay(String? id, DateTime date) {
    return habitsCollection
        .doc(id)
        .collection(_daysDone)
        .doc(date.dateFormatted)
        .get()
        .then((value) => value.exists);
  }

  // FRIENDS

  @override
  Future<List<PersonModel>> getFriendsDetails() {
    return userCollection
        .where(
          PersonModel.friendsTag,
          arrayContains: GetIt.I.get<IFireAuth>().getUid(),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => PersonModel.fromJson(
                  e.data() as Map<String, dynamic>,
                  e.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<List<PersonModel>> getPendingFriends() {
    return userCollection
        .where(
          PersonModel.pendingFriendsTag,
          arrayContains: GetIt.I.get<IFireAuth>().getUid(),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => PersonModel.fromJson(
                  e.data() as Map<String, dynamic>,
                  e.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<List<PersonModel>> getRankingFriends(int limit) {
    return userCollection
        .orderBy(PersonModel.scoreTag, descending: true)
        .where(
          PersonModel.friendsTag,
          arrayContains: GetIt.I.get<IFireAuth>().getUid(),
        )
        .limit(limit)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => PersonModel.fromJson(
                  e.data() as Map<String, dynamic>,
                  e.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<List<PersonModel>> searchEmail(
    String email,
    List<String?> myPendingFriends,
  ) {
    return userCollection
        .where(PersonModel.emailTag, isEqualTo: email)
        .get()
        .then(
          (value) => value.docs.map((e) {
            PersonModel person =
                PersonModel.fromJson(e.data() as Map<String, dynamic>, e.id);
            var state = 0;

            if (person.friends.contains(GetIt.I.get<IFireAuth>().getUid())) {
              state = 1;
            } else if (myPendingFriends.contains(person.uid)) {
              state = 2;
            } else if (person.pendingFriends
                .contains(GetIt.I.get<IFireAuth>().getUid())) {
              state = 3;
            }

            person.state = state;
            return person;
          }).toList(),
        );
  }

  @override
  Future<String> friendRequest(String? uid) async {
    var person = (await userDoc.get().then(
          (value) => PersonModel.fromJson(
            value.data() as Map<String, dynamic>,
            value.id,
          ),
        ));
    if (person.friends.length >= maxFriends) {
      throw 'Máximo de amigos atingido.';
    }

    if (person.friends.contains(uid)) {
      throw 'Vocês já são amigos.';
    }

    if (person.pendingFriends.contains(uid)) {
      throw 'Você já enviou um pedido.';
    }

    var friendData = (await userCollection.doc(uid).get().then(
          (value) => PersonModel.fromJson(
            value.data() as Map<String, dynamic>,
            value.id,
          ),
        ));
    if (friendData.pendingFriends.contains(GetIt.I.get<IFireAuth>().getUid())) {
      throw 'Já tem uma solicitação.';
    }

    return userDoc.update({
      PersonModel.pendingFriendsTag: FieldValue.arrayUnion([uid])
    }).then((value) => friendData.fcmToken);
  }

  @override
  Future<String> acceptRequest(String? uid) async {
    if ((await userDoc.get().then(
                  (value) => PersonModel.fromJson(
                    value.data() as Map<String, dynamic>,
                    value.id,
                  ),
                ))
            .friends
            .length >=
        maxFriends) {
      throw 'Máximo de amigos atingido.';
    }

    var friendData = (await userCollection.doc(uid).get().then(
          (value) => PersonModel.fromJson(
            value.data() as Map<String, dynamic>,
            value.id,
          ),
        ));
    if (friendData.friends.length >= maxFriends) {
      throw 'Seu amigo atingiu o máximo de amigos.';
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(userDoc, {
      PersonModel.friendsTag: FieldValue.arrayUnion([uid])
    });
    batch.update(userCollection.doc(uid), {
      PersonModel.pendingFriendsTag:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()]),
      PersonModel.friendsTag:
          FieldValue.arrayUnion([GetIt.I.get<IFireAuth>().getUid()])
    });

    return batch.commit().then((value) => friendData.fcmToken);
  }

  @override
  Future declineRequest(String? uid) {
    return userCollection.doc(uid).update({
      PersonModel.pendingFriendsTag:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()])
    });
  }

  @override
  Future cancelFriendRequest(String? uid) {
    return userDoc.update({
      PersonModel.pendingFriendsTag: FieldValue.arrayRemove([uid])
    });
  }

  @override
  Future removeFriend(String? uid) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(userCollection.doc(uid), {
      PersonModel.friendsTag:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()])
    });
    batch.update(userDoc, {
      PersonModel.friendsTag: FieldValue.arrayRemove([uid])
    });

    return batch.commit();
  }

  // COMPETITION

  @override
  Future<List<CompetitionModel>> getCompetitions() {
    return competitionCollection
        .where(
          CompetitionModel.competitorsIdTag,
          arrayContains: GetIt.I.get<IFireAuth>().getUid(),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => CompetitionModel.fromJson(
                  e.data() as Map<String, dynamic>,
                  e.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<CompetitionModel> getCompetition(String? id) {
    return competitionCollection.doc(id).get().then(
          (value) => CompetitionModel.fromJson(
            value.data() as Map<String, dynamic>,
            value.id,
          ),
        );
  }

  @override
  Future<List<CompetitionModel>> getPendingCompetitions() {
    return competitionCollection
        .where(
          CompetitionModel.invitationsTag,
          arrayContains: GetIt.I.get<IFireAuth>().getUid(),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => CompetitionModel.fromJson(
                  e.data() as Map<String, dynamic>,
                  e.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<CompetitionModel> createCompetition(
    String title,
    DateTime date,
    List<CompetitorModel> competitors,
    List<String> invitations,
  ) {
    DocumentReference doc = competitionCollection.doc();
    final competition = CompetitionModel(
      id: doc.id,
      title: title,
      initialDate: date,
      competitors: competitors,
    );

    return doc.set(competition.toJson()).then((value) => competition);
  }

  @override
  Future updateCompetition(String? competitionId, String title) {
    return competitionCollection
        .doc(competitionId)
        .update({CompetitionModel.titleTag: title});
  }

  @override
  Future updateCompetitor(String competitionId, String habitId) {
    return competitionCollection.doc(competitionId).set(
      {
        CompetitionModel.competitorsTag: {
          GetIt.I.get<IFireAuth>().getUid(): {
            CompetitorModel.habitIdTag: habitId
          }
        }
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future inviteCompetitor(String? competitionId, List<String?> competitorId) {
    return competitionCollection.doc(competitionId).update(
      {CompetitionModel.invitationsTag: FieldValue.arrayUnion(competitorId)},
    );
  }

  @override
  Future removeCompetitor(String? competitionId, String uid, bool removeAll) {
    if (removeAll) {
      return competitionCollection.doc(competitionId).delete();
    } else {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.update(competitionCollection.doc(competitionId), {
        CompetitionModel.competitorsIdTag: FieldValue.arrayRemove([uid])
      });

      batch.update(
        competitionCollection.doc(competitionId),
        {'${CompetitionModel.competitorsTag}.$uid': FieldValue.delete()},
      );

      return batch.commit();
    }
  }

  @override
  Future acceptCompetitionRequest(
    String? competitionId,
    CompetitorModel competitor,
  ) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = competitionCollection.doc(competitionId);

    batch.set(
      doc,
      {
        CompetitionModel.competitorsTag: {
          GetIt.I.get<IFireAuth>().getUid(): competitor.toJson()
        }
      },
      SetOptions(merge: true),
    );

    batch.update(doc, {
      CompetitionModel.competitorsIdTag:
          FieldValue.arrayUnion([GetIt.I.get<IFireAuth>().getUid()])
    });
    batch.update(doc, {
      CompetitionModel.invitationsTag:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()])
    });

    return batch.commit();
  }

  @override
  Future declineCompetitionRequest(String? competitionId) {
    return competitionCollection.doc(competitionId).update({
      CompetitionModel.invitationsTag:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()])
    });
  }
}
