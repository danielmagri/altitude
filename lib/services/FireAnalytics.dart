import 'package:firebase_analytics/firebase_analytics.dart';

class FireAnalytics {
  static final FireAnalytics _singleton = new FireAnalytics._internal();
  FirebaseAnalytics analytics = FirebaseAnalytics();

  factory FireAnalytics() {
    return _singleton;
  }

  FireAnalytics._internal();

  void sendNewHabit(String habit, String color, String freqType, int freqTime, String hasReminder) {
    try {
      analytics.logEvent(
        name: 'new_habit',
        parameters: <String, dynamic>{
          'habit': habit.trim().toLowerCase(),
          'color': color,
          'freq_type': freqType,
          'freq_time': freqTime,
          'hasReminder': hasReminder,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void sendDoneHabit(String page, int hour) {
    try {
      analytics.logEvent(
        name: 'done_habit',
        parameters: <String, dynamic>{
          'page': page,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void sendNextLevel(String level) {
    try {
      analytics.logEvent(
        name: 'next_level',
        parameters: <String, dynamic>{
          'level': level,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void sendReadCue() {
    try {
      analytics.logEvent(
        name: 'read_cue',
      );
    } catch (e) {
      print(e);
    }
  }

  void sendSetCue(String habit, String cue) {
    try {
      analytics.logEvent(
        name: 'set_cue',
        parameters: <String, dynamic>{
          'habit': habit.trim().toLowerCase(),
          'cue': cue.trim().toLowerCase(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void sendRemoveCue(String habit) {
    try {
      analytics.logEvent(
        name: 'remove_cue',
        parameters: <String, dynamic>{
          'habit': habit.trim().toLowerCase(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void sendSetAlarm(String habit, int type, int hour, int minute, String days) {
    try {
      analytics.logEvent(
        name: 'set_alarm',
        parameters: <String, dynamic>{
          'habit': habit,
          'type': type,
          'time': "$hour:$minute",
          'days': days,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void sendRemoveAlarm(String habit) {
    try {
      analytics.logEvent(
        name: 'remove_alarm',
        parameters: <String, dynamic>{
          'habit': habit.trim().toLowerCase(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void sendCreateCompetition(String title, String habitName, int friends) {
    try {
      analytics.logEvent(
        name: 'create_competition',
        parameters: <String, dynamic>{
          'title': title.trim().toLowerCase(),
          'habit_name': habitName.trim().toLowerCase(),
          'friends': friends,
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
