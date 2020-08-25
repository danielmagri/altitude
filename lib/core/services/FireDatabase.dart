import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get user => firestore.collection('users').doc(FireAuth().getUid());
  CollectionReference get habits => user.collection('habits');

  Future<Result<Habit>> addHabit(Habit habit) {
    DocumentReference doc = habits.doc();

    return doc
        .set(habit.toJson())
        .then<Result<Habit>>((value) => Result.success(habit))
        .catchError((error) => Result.error(error));
  }

  Future<Result<List<Habit>>> getHabits() {
    return habits
        .get()
        .then((value) => Result.success(value.docs.map((e) => Habit.toDomain(e.data())).toList()))
        .catchError((error) => Result.error(error));
  }
}
