import 'package:firebase_analytics/firebase_analytics.dart';

abstract class IFireAnalytics {
  FirebaseAnalytics get analytics;

  void setUserId(String uid);

  void sendNewHabit(
    String? habit,
    String color,
    String freqType,
    int? freqTime,
    String hasReminder,
  );

  void sendRemoveHabit(String? habit);

  void sendDoneHabit(String page, int hour);

  void sendNextLevel(String level);

  void sendReadCue();

  void sendSetCue(String? habit, String cue);

  void sendRemoveCue(String? habit);

  void sendSetAlarm(String habit, int type, int hour, int minute, String days);

  void sendRemoveAlarm(String? habit);

  void sendFriendRequest(bool canceled);

  void sendFriendResponse(bool accepted);

  void sendCreateCompetition(String title, String? habitName, int friends);

  void sendGoCompetition(String index);

  void sendLearn(String keyword);

  void sendGenerateLead();
}
