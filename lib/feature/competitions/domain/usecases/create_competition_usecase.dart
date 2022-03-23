import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class CreateCompetitionUsecase
    extends BaseUsecase<CreateCompetitionParams, Competition> {
  final IFireDatabase _fireDatabase;
  final IFireMessaging _fireMessaging;
  final IFireFunctions _fireFunctions;
  final IFireAnalytics _fireAnalytics;
  final IFireAuth _fireAuth;
  final Memory _memory;

  CreateCompetitionUsecase(this._fireDatabase, this._fireMessaging,
      this._fireFunctions, this._fireAnalytics, this._fireAuth, this._memory);

  @override
  Future<Competition> getRawFuture(CreateCompetitionParams params) async {
    DateTime date = DateTime.now().today;

    Competitor competitor = Competitor(
        uid: _fireAuth.getUid(),
        name: _fireAuth.getName(),
        fcmToken: await _fireMessaging.getToken,
        habitId: params.habit.id,
        color: params.habit.colorCode,
        score: await _fireDatabase.hasDoneAtDay(params.habit.id, date)
            ? ScoreControl.DAY_DONE_POINT
            : 0,
        you: true);

    Competition competition = await _fireDatabase.createCompetition(Competition(
        title: params.title,
        initialDate: date,
        competitors: [competitor],
        invitations: params.invitations));

    for (String token in params.invitationsToken) {
      await _fireFunctions.sendNotification(
          "Convite de competição",
          "${_fireAuth.getName()} te convidou a participar do ${params.title}",
          token);
    }

    _fireAnalytics.sendCreateCompetition(
        params.title, params.habit.habit, params.invitations.length);

    _memory.competitions.add(competition);

    return competition;
  }
}

class CreateCompetitionParams {
  final String title;
  final Habit habit;
  final List<String> invitations;
  final List<String> invitationsToken;

  CreateCompetitionParams(
      {required this.title,
      required this.habit,
      required this.invitations,
      required this.invitationsToken});
}
