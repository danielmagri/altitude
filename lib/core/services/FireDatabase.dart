import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get userDoc => firestore.collection('users').doc(FireAuth().getUid());
  CollectionReference get habitsCollection => userDoc.collection('habits');

  // PERSON

  Future<Person> getPerson() {
    return userDoc.get().then((value) => Person.fromJson(value.data()));
  }

  Future updateLevel(int level) {
    return userDoc.update({Person.LEVEL: level});
  }

  // HABIT

  Future<Habit> addHabit(Habit habit) {
    DocumentReference doc = habitsCollection.doc();
    habit.id = doc.id;

    return doc.set(habit.toJson()).then((value) => habit);
  }

  Future<List<Habit>> getHabits() {
    return habitsCollection.get().then((value) => value.docs.map((e) => Habit.fromJson(e.data())).toList());
  }

  Future<Habit> getHabit(String id) {
    return habitsCollection.doc(id).get().then((value) => Habit.fromJson(value.data()));
  }

  Future completeHabit(String habitId, int totalScore, int habitScore, int daysDoneCount, DayDone dayDone) {
    DocumentReference habitDoc = habitsCollection.doc(habitId);
    CollectionReference daysDoneCollection = habitDoc.collection('days_done');

    return daysDoneCollection.doc(dayDone.dateFormatted).get().then((date) {
      if (!date.exists) {
        WriteBatch batch = FirebaseFirestore.instance.batch();

        batch.update(userDoc, {Person.SCORE: totalScore});
        batch.update(habitDoc, {Habit.SCORE: habitScore, Habit.DAYS_DONE_COUNT: daysDoneCount});
        batch.set(daysDoneCollection.doc(dayDone.dateFormatted), dayDone.toJson());

        return batch.commit();
      } else {
        throw "Hábito já foi feito";
      }
    });
  }

  // DAYS DONE

  Future<List<DayDone>> getDaysDone(String id, DateTime startDate, DateTime endDate) {
    return habitsCollection
        .doc(id)
        .collection('days_done')
        .get()
        .then((value) => value.docs.map((e) => DayDone.fromJson(e.data())).toList());
  }
}
