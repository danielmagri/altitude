import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/model/pair.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IFireDatabase)
class FireDatabase implements IFireDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const _USERS = 'users';
  static const _HABITS = 'habits';
  static const _COMPETITIONS = 'competitions';
  static const _DAYS_DONE = 'days_done';

  CollectionReference get userCollection => firestore.collection(_USERS);
  DocumentReference get userDoc =>
      userCollection.doc(GetIt.I.get<IFireAuth>().getUid());
  CollectionReference get habitsCollection => userDoc.collection(_HABITS);
  CollectionReference get competitionCollection =>
      firestore.collection(_COMPETITIONS);

  // TRANSFER DATA

  @override
  Future<String> transferHabit(Habit habit, int? reminderCounter,
      List<String?> competitionsId, List<DayDone> daysDone) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = habitsCollection.doc();
    habit.id = doc.id;
    batch.set(doc, habit.toJson());
    if (reminderCounter != null) {
      batch.update(userDoc, {Person.REMINDER_COUNTER: reminderCounter});
    }

    for (String? competitionId in competitionsId) {
      batch.set(
        competitionCollection.doc(competitionId),
        {
          Competition.COMPETITORS: {
            GetIt.I.get<IFireAuth>().getUid(): {Competitor.HABIT_ID: habit.id}
          }
        },
        SetOptions(merge: true),
      );
    }

    CollectionReference daysDoneCollection = doc.collection(_DAYS_DONE);
    for (DayDone dayDone in daysDone) {
      batch.set(
        daysDoneCollection.doc(dayDone.dateFormatted),
        dayDone.toJson(),
      );
    }

    return batch.commit().then((value) => doc.id);
  }

  @override
  Future transferDayDonePlus(String habitId, List<DayDone> daysDone) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection(_DAYS_DONE);
    for (DayDone dayDone in daysDone) {
      batch.set(
        daysDoneCollection.doc(dayDone.dateFormatted),
        dayDone.toJson(),
      );
    }

    return batch.commit();
  }

  @override
  Future updateTotalScore(int? score, int level) {
    return userDoc.update({Person.SCORE: score, Person.LEVEL: level});
  }

  @override
  Future updateHabitScore(String? habitId, int score,
      List<Pair<String?, int>> competitionsScore) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference habitDoc = habitsCollection.doc(habitId);

    batch.update(habitDoc, {Habit.SCORE: score});

    for (Pair<String?, int> item in competitionsScore) {
      batch.set(
        competitionCollection.doc(item.first),
        {
          Competition.COMPETITORS: {
            GetIt.I.get<IFireAuth>().getUid(): {Competitor.SCORE: item.second}
          }
        },
        SetOptions(merge: true),
      );
    }

    return batch.commit();
  }

  // PERSON

  @override
  Future createPerson(Person person) {
    return userDoc.set(person.toJson(), SetOptions(merge: true));
  }

  @override
  Future<Person> getPerson() {
    return userDoc.get().then(
          (value) =>
              Person.fromJson(value.data() as Map<String, dynamic>, value.id),
        );
  }

  @override
  Future updateName(String name, List<String?> competitionsId) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    userDoc.update({Person.NAME: name});

    if (competitionsId != null) {
      for (String? item in competitionsId) {
        batch.set(
          competitionCollection.doc(item),
          {
            Competition.COMPETITORS: {
              GetIt.I.get<IFireAuth>().getUid(): {Competitor.NAME: name}
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

    userDoc.update({Person.FCM_TOKEN: token});

    if (competitionsId != null) {
      for (String? item in competitionsId) {
        batch.set(
          competitionCollection.doc(item),
          {
            Competition.COMPETITORS: {
              GetIt.I.get<IFireAuth>().getUid(): {Competitor.FCM_TOKEN: token}
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
    return userDoc.update({Person.LEVEL: level});
  }

  // HABIT

  @override
  Future<Habit> addHabit(Habit habit, int? reminderCounter) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference doc = habitsCollection.doc();
    habit.id = doc.id;

    batch.set(doc, habit.toJson());
    if (reminderCounter != null) {
      batch.update(userDoc, {Person.REMINDER_COUNTER: reminderCounter});
    }
    return batch.commit().then((value) => habit);
  }

  @override
  Future<List<Habit>> getHabits() {
    return habitsCollection.get().then(
          (value) => value.docs
              .map((e) => Habit.fromJson(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Future<Habit> getHabit(String? id) {
    return habitsCollection
        .doc(id)
        .get()
        .then((value) => Habit.fromJson(value.data() as Map<String, dynamic>));
  }

  @override
  Future updateHabit(Habit habit,
      [Habit? inititalHabit, List<String?>? competitionsId]) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    if (inititalHabit != null &&
        competitionsId != null &&
        habit.colorCode != inititalHabit.colorCode) {
      for (String? item in competitionsId) {
        batch.set(
          competitionCollection.doc(item),
          {
            Competition.COMPETITORS: {
              GetIt.I.get<IFireAuth>().getUid(): {
                Competitor.COLOR: habit.colorCode
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
    Reminder? reminder,
  ) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      habitsCollection.doc(habitId),
      {Habit.REMINDER: reminder?.toJson()},
    );
    if (reminderCounter != null) {
      batch.update(userDoc, {Person.REMINDER_COUNTER: reminderCounter});
    }

    return batch.commit();
  }

  @override
  Future completeHabit(
    String? habitId,
    bool isAdd,
    int score,
    bool isLastDone,
    DayDone dayDone,
    List<String?> competitions,
  ) {
    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection(_DAYS_DONE);

    return daysDoneCollection.doc(dayDone.dateFormatted).get().then((date) {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      if (competitions != null) {
        for (String? item in competitions) {
          batch.set(
            competitionCollection.doc(item),
            {
              Competition.COMPETITORS: {
                GetIt.I.get<IFireAuth>().getUid(): {
                  Competitor.SCORE: FieldValue.increment(score)
                }
              }
            },
            SetOptions(merge: true),
          );
        }
      }

      Map<String, dynamic> habitMap = {};
      habitMap.putIfAbsent(Habit.SCORE, () => FieldValue.increment(score));
      habitMap.putIfAbsent(
        Habit.DAYS_DONE_COUNT,
        () => FieldValue.increment(isAdd ? 1 : -1),
      );

      if (!date.exists && isAdd) {
        if (isLastDone) {
          habitMap.putIfAbsent(Habit.LAST_DONE, () => dayDone.date);
        }
        batch.set(
          daysDoneCollection.doc(dayDone.dateFormatted),
          dayDone.toJson(),
        );
      } else if (date.exists && !isAdd) {
        if (isLastDone) habitMap.putIfAbsent(Habit.LAST_DONE, () => null);
        batch.delete(daysDoneCollection.doc(dayDone.dateFormatted));
      } else {
        if (date.exists && isAdd) {
          throw 'Você já completou esse dia';
        }
        throw 'Erro desconhecido';
      }

      batch.update(userDoc, {Person.SCORE: FieldValue.increment(score)});
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
  Future<List<DayDone>> getAllDaysDone(String? id) {
    return habitsCollection.doc(id).collection(_DAYS_DONE).get().then(
          (value) => value.docs.map((e) => DayDone.fromJson(e.data())).toList(),
        );
  }

  @override
  Future<List<DayDone>> getDaysDone(
      String? id, DateTime? startDate, DateTime endDate) {
    return habitsCollection
        .doc(id)
        .collection(_DAYS_DONE)
        .where(DayDone.DATE, isGreaterThanOrEqualTo: startDate)
        .where(DayDone.DATE, isLessThanOrEqualTo: endDate)
        .get()
        .then(
          (value) => value.docs.map((e) => DayDone.fromJson(e.data())).toList(),
        );
  }

  @override
  Future<bool> hasDoneAtDay(String? id, DateTime date) {
    return habitsCollection
        .doc(id)
        .collection(_DAYS_DONE)
        .doc(date.dateFormatted)
        .get()
        .then((value) => value.exists);
  }

  // FRIENDS

  @override
  Future<List<Person>> getFriendsDetails() {
    return userCollection
        .where(Person.FRIENDS, arrayContains: GetIt.I.get<IFireAuth>().getUid())
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Person.fromJson(e.data() as Map<String, dynamic>, e.id),
              )
              .toList(),
        );
  }

  @override
  Future<List<Person>> getPendingFriends() {
    return userCollection
        .where(
          Person.PENDING_FRIENDS,
          arrayContains: GetIt.I.get<IFireAuth>().getUid(),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Person.fromJson(e.data() as Map<String, dynamic>, e.id),
              )
              .toList(),
        );
  }

  @override
  Future<List<Person>> getRankingFriends(int limit) {
    return userCollection
        .orderBy(Person.SCORE, descending: true)
        .where(Person.FRIENDS, arrayContains: GetIt.I.get<IFireAuth>().getUid())
        .limit(limit)
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Person.fromJson(e.data() as Map<String, dynamic>, e.id),
              )
              .toList(),
        );
  }

  @override
  Future<List<Person>> searchEmail(
    String email,
    List<String?> myPendingFriends,
  ) {
    return userCollection.where(Person.EMAIL, isEqualTo: email).get().then(
          (value) => value.docs.map((e) {
            Person person =
                Person.fromJson(e.data() as Map<String, dynamic>, e.id);
            var state = 0;

            if (person.friends!.contains(GetIt.I.get<IFireAuth>().getUid())) {
              state = 1;
            } else if (myPendingFriends.contains(person.uid)) {
              state = 2;
            } else if (person.pendingFriends!
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
          (value) =>
              Person.fromJson(value.data() as Map<String, dynamic>, value.id),
        ));
    if (person.friends!.length >= MAX_FRIENDS) {
      throw 'Máximo de amigos atingido.';
    }

    if (person.friends!.contains(uid)) {
      throw 'Vocês já são amigos.';
    }

    if (person.pendingFriends!.contains(uid)) {
      throw 'Você já enviou um pedido.';
    }

    var friendData = (await userCollection.doc(uid).get().then(
          (value) =>
              Person.fromJson(value.data() as Map<String, dynamic>, value.id),
        ));
    if (friendData.pendingFriends!
        .contains(GetIt.I.get<IFireAuth>().getUid())) {
      throw 'Já tem uma solicitação.';
    }

    return userDoc.update({
      Person.PENDING_FRIENDS: FieldValue.arrayUnion([uid])
    }).then((value) => friendData.fcmToken!);
  }

  @override
  Future<String> acceptRequest(String? uid) async {
    if ((await userDoc.get().then(
                  (value) => Person.fromJson(
                    value.data() as Map<String, dynamic>,
                    value.id,
                  ),
                ))
            .friends!
            .length >=
        MAX_FRIENDS) {
      throw 'Máximo de amigos atingido.';
    }

    var friendData = (await userCollection.doc(uid).get().then(
          (value) =>
              Person.fromJson(value.data() as Map<String, dynamic>, value.id),
        ));
    if (friendData.friends!.length >= MAX_FRIENDS) {
      throw 'Seu amigo atingiu o máximo de amigos.';
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(userDoc, {
      Person.FRIENDS: FieldValue.arrayUnion([uid])
    });
    batch.update(userCollection.doc(uid), {
      Person.PENDING_FRIENDS:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()]),
      Person.FRIENDS: FieldValue.arrayUnion([GetIt.I.get<IFireAuth>().getUid()])
    });

    return batch.commit().then((value) => friendData.fcmToken!);
  }

  @override
  Future declineRequest(String? uid) {
    return userCollection.doc(uid).update({
      Person.PENDING_FRIENDS:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()])
    });
  }

  @override
  Future cancelFriendRequest(String? uid) {
    return userDoc.update({
      Person.PENDING_FRIENDS: FieldValue.arrayRemove([uid])
    });
  }

  @override
  Future removeFriend(String? uid) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(userCollection.doc(uid), {
      Person.FRIENDS:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()])
    });
    batch.update(userDoc, {
      Person.FRIENDS: FieldValue.arrayRemove([uid])
    });

    return batch.commit();
  }

  // COMPETITION

  @override
  Future<List<Competition>> getCompetitions() {
    return competitionCollection
        .where(
          Competition.COMPETITORS_ID,
          arrayContains: GetIt.I.get<IFireAuth>().getUid(),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Competition.fromJson(
                  e.data() as Map<String, dynamic>,
                  e.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<Competition> getCompetition(String? id) {
    return competitionCollection.doc(id).get().then(
          (value) => Competition.fromJson(
            value.data() as Map<String, dynamic>,
            value.id,
          ),
        );
  }

  @override
  Future<List<Competition>> getPendingCompetitions() {
    return competitionCollection
        .where(
          Competition.INVITATIONS,
          arrayContains: GetIt.I.get<IFireAuth>().getUid(),
        )
        .get()
        .then(
          (value) => value.docs
              .map(
                (e) => Competition.fromJson(
                  e.data() as Map<String, dynamic>,
                  e.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Future<Competition> createCompetition(Competition competition) {
    DocumentReference doc = competitionCollection.doc();
    competition.id = doc.id;

    return doc.set(competition.toJson()).then((value) => competition);
  }

  @override
  Future updateCompetition(String? competitionId, String title) {
    return competitionCollection
        .doc(competitionId)
        .update({Competition.TITLE: title});
  }

  @override
  Future updateCompetitor(String competitionId, String habitId) {
    return competitionCollection.doc(competitionId).set(
      {
        Competition.COMPETITORS: {
          GetIt.I.get<IFireAuth>().getUid(): {Competitor.HABIT_ID: habitId}
        }
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future inviteCompetitor(String? competitionId, List<String?> competitorId) {
    return competitionCollection
        .doc(competitionId)
        .update({Competition.INVITATIONS: FieldValue.arrayUnion(competitorId)});
  }

  @override
  Future removeCompetitor(String? competitionId, String uid, bool removeAll) {
    if (removeAll) {
      return competitionCollection.doc(competitionId).delete();
    } else {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.update(competitionCollection.doc(competitionId), {
        Competition.COMPETITORS_ID: FieldValue.arrayRemove([uid])
      });

      batch.update(
        competitionCollection.doc(competitionId),
        {'${Competition.COMPETITORS}.$uid': FieldValue.delete()},
      );

      return batch.commit();
    }
  }

  @override
  Future acceptCompetitionRequest(
    String? competitionId,
    Competitor competitor,
  ) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = competitionCollection.doc(competitionId);

    batch.set(
      doc,
      {
        Competition.COMPETITORS: {
          GetIt.I.get<IFireAuth>().getUid(): competitor.toJson()
        }
      },
      SetOptions(merge: true),
    );

    batch.update(doc, {
      Competition.COMPETITORS_ID:
          FieldValue.arrayUnion([GetIt.I.get<IFireAuth>().getUid()])
    });
    batch.update(doc, {
      Competition.INVITATIONS:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()])
    });

    return batch.commit();
  }

  @override
  Future declineCompetitionRequest(String? competitionId) {
    return competitionCollection.doc(competitionId).update({
      Competition.INVITATIONS:
          FieldValue.arrayRemove([GetIt.I.get<IFireAuth>().getUid()])
    });
  }
}
