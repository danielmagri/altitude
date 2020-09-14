import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get userDoc =>
      firestore.collection('users').doc(FireAuth().getUid());
  CollectionReference get habitsCollection => userDoc.collection('habits');

  // PERSON

  Future<Person> getPerson() {
    return userDoc.get().then((value) => Person.fromJson(value.data()));
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
    return habitsCollection.get().then(
        (value) => value.docs.map((e) => Habit.fromJson(e.data())).toList());
  }

  Future<Habit> getHabit(String id) {
    return habitsCollection
        .doc(id)
        .get()
        .then((value) => Habit.fromJson(value.data()));
  }

  Future updateReminder(
      String habitId, int reminderCounter, Reminder reminder) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
        habitsCollection.doc(habitId), {Habit.REMINDER: reminder?.toJson()});
    if (reminderCounter != null) {
      batch.update(userDoc, {Person.REMINDER_COUNTER: reminderCounter});
    }

    return batch.commit();
  }

  Future completeHabit(String habitId, bool isAdd, int totalScore,
      int habitScore, int daysDoneCount, bool isLastDone, DayDone dayDone) {
    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection('days_done');

    return daysDoneCollection.doc(dayDone.dateFormatted).get().then((date) {
      if (!date.exists && isAdd) {
        WriteBatch batch = FirebaseFirestore.instance.batch();

        Map<String, dynamic> habitMap = Map();
        habitMap.putIfAbsent(Habit.SCORE, () => habitScore);
        habitMap.putIfAbsent(Habit.DAYS_DONE_COUNT, () => daysDoneCount);
        if (isLastDone)
          habitMap.putIfAbsent(Habit.LAST_DONE, () => dayDone.date);

        batch.update(userDoc, {Person.SCORE: totalScore});
        batch.update(habitDoc, habitMap);
        batch.set(
            daysDoneCollection.doc(dayDone.dateFormatted), dayDone.toJson());

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

  // DAYS DONE

  Future<List<DayDone>> getDaysDone(
      String id, DateTime startDate, DateTime endDate) {
    return habitsCollection
        .doc(id)
        .collection('days_done')
        .where(DayDone.DATE, isGreaterThanOrEqualTo: startDate)
        .where(DayDone.DATE, isLessThanOrEqualTo: endDate)
        .get()
        .then((value) =>
            value.docs.map((e) => DayDone.fromJson(e.data())).toList());
  }
}
