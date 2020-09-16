import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get userCollection => firestore.collection('users');
  DocumentReference get userDoc => userCollection.doc(FireAuth().getUid());
  CollectionReference get habitsCollection => userDoc.collection('habits');
  CollectionReference get competitionCollection => firestore.collection('competitions');

  // PERSON

  Future<Person> getPerson() {
    return userDoc.get().then((value) => Person.fromJson(value.data(), value.id));
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

  Future updateHabit(Habit habit) {
    return habitsCollection.doc(habit.id).update(habit.toJson());
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
      String habitId, bool isAdd, int totalScore, int habitScore, int daysDoneCount, bool isLastDone, DayDone dayDone) {
    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection('days_done');

    return daysDoneCollection.doc(dayDone.dateFormatted).get().then((date) {
      if (!date.exists && isAdd) {
        WriteBatch batch = FirebaseFirestore.instance.batch();

        Map<String, dynamic> habitMap = Map();
        habitMap.putIfAbsent(Habit.SCORE, () => habitScore);
        habitMap.putIfAbsent(Habit.DAYS_DONE_COUNT, () => daysDoneCount);
        if (isLastDone) habitMap.putIfAbsent(Habit.LAST_DONE, () => dayDone.date);

        batch.update(userDoc, {Person.SCORE: totalScore});
        batch.update(habitDoc, habitMap);
        batch.set(daysDoneCollection.doc(dayDone.dateFormatted), dayDone.toJson());

        return batch.commit();
      } else if (date.exists && !isAdd) {
        WriteBatch batch = FirebaseFirestore.instance.batch();

        Map<String, dynamic> habitMap = Map();
        habitMap.putIfAbsent(Habit.SCORE, () => habitScore);
        habitMap.putIfAbsent(Habit.DAYS_DONE_COUNT, () => daysDoneCount);
        if (isLastDone) habitMap.putIfAbsent(Habit.LAST_DONE, () => null);

        batch.update(userDoc, {Person.SCORE: totalScore});
        batch.update(habitDoc, habitMap);
        batch.delete(daysDoneCollection.doc(dayDone.dateFormatted));

        return batch.commit();
      } else {
        throw "Erro desconhecido";
      }
    });
  }

  Future deleteHabit(String id) {
    return habitsCollection.doc(id).delete();
  }

  // DAYS DONE

  Future<List<DayDone>> getDaysDone(String id, DateTime startDate, DateTime endDate) {
    return habitsCollection
        .doc(id)
        .collection('days_done')
        .where(DayDone.DATE, isGreaterThanOrEqualTo: startDate)
        .where(DayDone.DATE, isLessThanOrEqualTo: endDate)
        .get()
        .then((value) => value.docs.map((e) => DayDone.fromJson(e.data())).toList());
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
}
