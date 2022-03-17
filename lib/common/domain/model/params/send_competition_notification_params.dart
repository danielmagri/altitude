import 'package:altitude/common/model/Competition.dart';

class SendCompetitionNotificationParams {
  final int earnedScore;
  final List<Competition> competitions;

  SendCompetitionNotificationParams(
      {required this.earnedScore, required this.competitions});
}
