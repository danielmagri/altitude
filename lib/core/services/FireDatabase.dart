import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';

class FireDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const _USERS = 'users';
  static const _HABITS = 'habits';
  static const _COMPETITIONS = 'competitions';
  static const _DAYS_DONE = 'days_done';

  CollectionReference get userCollection => firestore.collection(_USERS);
  DocumentReference get userDoc => userCollection.doc(FireAuth().getUid());
  CollectionReference get habitsCollection => userDoc.collection(_HABITS);
  CollectionReference get competitionCollection => firestore.collection(_COMPETITIONS);

  // TRANSFER DATA

  Future<String> transferHabit(Habit habit, int reminderCounter, List<String> competitionsId, List<DayDone> daysDone) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = habitsCollection.doc();
    habit.id = doc.id;
    batch.set(doc, habit.toJson());
    if (reminderCounter != null) {
      batch.update(userDoc, {Person.REMINDER_COUNTER: reminderCounter});
    }

    for (String competitionId in competitionsId) {
      batch.set(
          competitionCollection.doc(competitionId),
          {
            Competition.COMPETITORS: {
              FireAuth().getUid(): {Competitor.HABIT_ID: habit.id}
            }
          },
          SetOptions(merge: true));
    }

    CollectionReference daysDoneCollection = doc.collection(_DAYS_DONE);
    for (DayDone dayDone in daysDone) {
      batch.set(daysDoneCollection.doc(dayDone.dateFormatted), dayDone.toJson());
    }

    batch.update(userDoc, {Person.SCORE: FieldValue.increment(habit.score)});

    return batch.commit().then((value) => doc.id);
  }

  Future transferDayDonePlus(String habitId, List<DayDone> daysDone) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection(_DAYS_DONE);
    for (DayDone dayDone in daysDone) {
      batch.set(daysDoneCollection.doc(dayDone.dateFormatted), dayDone.toJson());
    }

    return batch.commit();
  }

  // PERSON

  Future createPerson(Person person) {
    return userDoc.set(person.toJson(), SetOptions(merge: true));
  }

  Future<Person> getPerson() {
    return userDoc.get().then((value) => Person.fromJson(value.data(), value.id));
  }

  Future updateName(String name, List<String> competitionsId) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    userDoc.update({Person.NAME: name});

    if (competitionsId != null) {
      for (String item in competitionsId) {
        batch.set(
            competitionCollection.doc(item),
            {
              Competition.COMPETITORS: {
                FireAuth().getUid(): {Competitor.NAME: name}
              }
            },
            SetOptions(merge: true));
      }
    }

    return batch.commit();
  }

  Future updateLevel(int level) {
    return userDoc.update({Person.LEVEL: level});
  }

  // HABIT

  Future<Habit> addHabit(Habit habit, int reminderCounter) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference doc = habitsCollection.doc();
    habit.id = doc.id;

    batch.set(doc, habit.toJson());
    if (reminderCounter != null) {
      batch.update(userDoc, {Person.REMINDER_COUNTER: reminderCounter});
    }
    return batch.commit().then((value) => habit);
  }

  Future<List<Habit>> getHabits() {
    return habitsCollection.get().then((value) => value.docs.map((e) => Habit.fromJson(e.data())).toList());
  }

  Future<Habit> getHabit(String id) {
    return habitsCollection.doc(id).get().then((value) => Habit.fromJson(value.data()));
  }

  Future updateHabit(Habit habit, [Habit inititalHabit, List<String> competitionsId]) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    if (inititalHabit != null && competitionsId != null && habit.colorCode != inititalHabit.colorCode) {
      for (String item in competitionsId) {
        batch.set(
            competitionCollection.doc(item),
            {
              Competition.COMPETITORS: {
                FireAuth().getUid(): {Competitor.COLOR: habit.colorCode}
              }
            },
            SetOptions(merge: true));
      }
    }

    batch.update(habitsCollection.doc(habit.id), habit.toJson());

    return batch.commit();
  }

  Future updateReminder(String habitId, int reminderCounter, Reminder reminder) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(habitsCollection.doc(habitId), {Habit.REMINDER: reminder?.toJson()});
    if (reminderCounter != null) {
      batch.update(userDoc, {Person.REMINDER_COUNTER: reminderCounter});
    }

    return batch.commit();
  }

  Future completeHabit(
      String habitId, bool isAdd, int score, bool isLastDone, DayDone dayDone, List<String> competitions) {
    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection(_DAYS_DONE);

    return daysDoneCollection.doc(dayDone.dateFormatted).get().then((date) {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      if (competitions != null) {
        for (String item in competitions) {
          batch.set(
              competitionCollection.doc(item),
              {
                Competition.COMPETITORS: {
                  FireAuth().getUid(): {Competitor.SCORE: FieldValue.increment(score)}
                }
              },
              SetOptions(merge: true));
        }
      }

      Map<String, dynamic> habitMap = Map();
      habitMap.putIfAbsent(Habit.SCORE, () => FieldValue.increment(score));
      habitMap.putIfAbsent(Habit.DAYS_DONE_COUNT, () => FieldValue.increment(isAdd ? 1 : -1));

      if (!date.exists && isAdd) {
        if (isLastDone) habitMap.putIfAbsent(Habit.LAST_DONE, () => dayDone.date);
        batch.set(daysDoneCollection.doc(dayDone.dateFormatted), dayDone.toJson());
      } else if (date.exists && !isAdd) {
        if (isLastDone) habitMap.putIfAbsent(Habit.LAST_DONE, () => null);
        batch.delete(daysDoneCollection.doc(dayDone.dateFormatted));
      } else {
        if (date.exists && isAdd) {
          throw "Você já completou esse dia";
        }
        throw "Erro desconhecido";
      }

      batch.update(userDoc, {Person.SCORE: FieldValue.increment(score)});
      batch.update(habitDoc, habitMap);

      return batch.commit();
    });
  }

  Future deleteHabit(String id) {
    return habitsCollection.doc(id).delete();
  }

  // DAYS DONE

  Future<List<DayDone>> getAllDaysDone(String id) {
    return habitsCollection
        .doc(id)
        .collection(_DAYS_DONE)
        .get()
        .then((value) => value.docs.map((e) => DayDone.fromJson(e.data())).toList());
  }

  Future<List<DayDone>> getDaysDone(String id, DateTime startDate, DateTime endDate) {
    return habitsCollection
        .doc(id)
        .collection(_DAYS_DONE)
        .where(DayDone.DATE, isGreaterThanOrEqualTo: startDate)
        .where(DayDone.DATE, isLessThanOrEqualTo: endDate)
        .get()
        .then((value) => value.docs.map((e) => DayDone.fromJson(e.data())).toList());
  }

  Future<bool> hasDoneAtDay(String id, DateTime date) {
    return habitsCollection.doc(id).collection(_DAYS_DONE).doc(date.dateFormatted).get().then((value) => value.exists);
  }

  // FRIENDS

  Future<List<Person>> getFriendsDetails() {
    return userCollection
        .where(Person.FRIENDS, arrayContains: FireAuth().getUid())
        .get()
        .then((value) => value.docs.map((e) => Person.fromJson(e.data(), e.id)).toList());
  }

  Future<List<Person>> getRankingFriends(int limit) {
    return userCollection
        .orderBy(Person.SCORE, descending: true)
        .where(Person.FRIENDS, arrayContains: FireAuth().getUid())
        .limit(limit)
        .get()
        .then((value) => value.docs.map((e) => Person.fromJson(e.data(), e.id)).toList());
  }

  Future<List<Person>> searchEmail(String email, List<String> myPendingFriends) {
    return userCollection.where(Person.EMAIL, isEqualTo: email).get().then((value) => value.docs.map((e) {
          Person person = Person.fromJson(e.data(), e.id);
          var state = 0;

          if (person.friends.contains(FireAuth().getUid())) {
            state = 1;
          } else if (myPendingFriends.contains(person.uid)) {
            state = 2;
          } else if (person.pendingFriends.contains(FireAuth().getUid())) {
            state = 3;
          }

          person.state = state;
          return person;
        }).toList());
  }

  // COMPETITION

  Future<List<Competition>> getCompetitions() {
    return competitionCollection
        .where(Competition.COMPETITORS_ID, arrayContains: FireAuth().getUid())
        .get()
        .then((value) => value.docs.map((e) => Competition.fromJson(e.data(), e.id)).toList());
  }

  Future<Competition> getCompetition(String id) {
    return competitionCollection.doc(id).get().then((value) => Competition.fromJson(value.data(), value.id));
  }

  Future<List<Competition>> getPendingCompetitions() {
    return competitionCollection
        .where(Competition.INVITATIONS, arrayContains: FireAuth().getUid())
        .get()
        .then((value) => value.docs.map((e) => Competition.fromJson(e.data(), e.id)).toList());
  }

  Future<Competition> createCompetition(Competition competition) {
    DocumentReference doc = competitionCollection.doc();
    competition.id = doc.id;

    return doc.set(competition.toJson()).then((value) => competition);
  }

  Future updateCompetition(String competitionId, String title) {
    return competitionCollection.doc(competitionId).update({Competition.TITLE: title});
  }

  Future updateCompetitor(String competitionId, String habitId) {
    return competitionCollection.doc(competitionId).set({
      Competition.COMPETITORS: {
        FireAuth().getUid(): {Competitor.HABIT_ID: habitId}
      }
    }, SetOptions(merge: true));
  }

  Future inviteCompetitor(String competitionId, List<String> competitorId) {
    return competitionCollection
        .doc(competitionId)
        .update({Competition.INVITATIONS: FieldValue.arrayUnion(competitorId)});
  }

  Future removeCompetitor(String competitionId, String uid, bool removeAll) {
    if (removeAll) {
      return competitionCollection.doc(competitionId).delete();
    } else {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.update(competitionCollection.doc(competitionId), {
        Competition.COMPETITORS_ID: FieldValue.arrayRemove([uid])
      });

      batch.update(competitionCollection.doc(competitionId), {"${Competition.COMPETITORS}.$uid": FieldValue.delete()});

      return batch.commit();
    }
  }

  Future acceptCompetitionRequest(String competitionId, Competitor competitor) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = competitionCollection.doc(competitionId);

    batch.set(
        doc,
        {
          Competition.COMPETITORS: {FireAuth().getUid(): competitor.toJson()}
        },
        SetOptions(merge: true));

    batch.update(doc, {
      Competition.COMPETITORS_ID: FieldValue.arrayUnion([FireAuth().getUid()])
    });
    batch.update(doc, {
      Competition.INVITATIONS: FieldValue.arrayRemove([FireAuth().getUid()])
    });

    return batch.commit();
  }

  Future declineCompetitionRequest(String competitionId) {
    return competitionCollection.doc(competitionId).update({
      Competition.INVITATIONS: FieldValue.arrayRemove([FireAuth().getUid()])
    });
  }
}