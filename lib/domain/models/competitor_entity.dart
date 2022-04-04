import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';

class Competitor {
  Competitor({
    required this.uid,
    required this.name,
    required this.fcmToken,
    required this.habitId,
    required this.color,
    int? score,
    bool? you,
  })  : you = you ?? serviceLocator.get<IFireAuth>().getUid() == uid,
        score = score ?? 0;

  final String uid;
  final String name;
  final String fcmToken;

  final String habitId;
  int color;
  int score;

  bool you;
}
