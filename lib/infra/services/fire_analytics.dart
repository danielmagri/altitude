import 'dart:developer' show log;

import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IFireAnalytics)
class FireAnalytics implements IFireAnalytics {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  FirebaseAnalytics get analytics => _analytics;

  @override
  void setUserId(String uid) {
    analytics.setUserId(id: uid);
  }

  @override
  void sendNewHabit(
    String? habit,
    String color,
    String freqType,
    int? freqTime,
    String hasReminder,
  ) {
    try {
      analytics.logEvent(
        name: 'new_habit',
        parameters: <String, dynamic>{
          'habit': habit!.trim().toLowerCase(),
          'color': color,
          'freq_type': freqType,
          'freq_time': freqTime,
          'hasReminder': hasReminder,
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendRemoveHabit(String? habit) {
    try {
      analytics.logEvent(
        name: 'remove_habit',
        parameters: <String, dynamic>{
          'habit': habit!.trim().toLowerCase(),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendDoneHabit(String page, int hour) {
    try {
      analytics.logEvent(
        name: 'done_habit',
        parameters: <String, dynamic>{'page': page, 'hour': hour.toString()},
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendNextLevel(String level) {
    try {
      analytics.logEvent(
        name: 'next_level',
        parameters: <String, dynamic>{
          'level': level,
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendReadCue() {
    try {
      analytics.logEvent(
        name: 'read_cue',
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendSetCue(String? habit, String cue) {
    try {
      analytics.logEvent(
        name: 'set_cue',
        parameters: <String, dynamic>{
          'habit': habit!.trim().toLowerCase(),
          'cue': cue.trim().toLowerCase(),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendRemoveCue(String? habit) {
    try {
      analytics.logEvent(
        name: 'remove_cue',
        parameters: <String, dynamic>{
          'habit': habit!.trim().toLowerCase(),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendSetAlarm(String habit, int type, int hour, int minute, String days) {
    try {
      analytics.logEvent(
        name: 'set_alarm',
        parameters: <String, dynamic>{
          'habit': habit,
          'type': type,
          'time': '$hour:$minute',
          'days': days,
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendRemoveAlarm(String? habit) {
    try {
      analytics.logEvent(
        name: 'remove_alarm',
        parameters: <String, dynamic>{
          'habit': habit!.trim().toLowerCase(),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendFriendRequest(bool canceled) {
    try {
      analytics.logEvent(
        name: 'friend_request',
        parameters: <String, dynamic>{
          'state': canceled ? 'Enviado' : 'Cancelado',
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendFriendResponse(bool accepted) {
    try {
      analytics.logEvent(
        name: 'friend_response',
        parameters: <String, dynamic>{
          'state': accepted ? 'Aceito' : 'Recusado',
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendCreateCompetition(String title, String? habitName, int friends) {
    try {
      analytics.logEvent(
        name: 'create_competition',
        parameters: <String, dynamic>{
          'title': title.trim().toLowerCase(),
          'habit_name': habitName!.trim().toLowerCase(),
          'friends': friends,
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendGoCompetition(String index) {
    try {
      analytics.logEvent(
        name: 'go_competition_from_details',
        parameters: <String, dynamic>{
          'text': index,
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendLearn(String keyword) {
    try {
      analytics.logEvent(
        name: 'learn_text',
        parameters: <String, dynamic>{
          'text': keyword,
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void sendGenerateLead() {
    try {
      analytics.logGenerateLead();
    } catch (e) {
      log(e.toString());
    }
  }
}
