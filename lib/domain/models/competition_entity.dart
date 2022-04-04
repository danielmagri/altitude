import 'package:altitude/common/model/Competitor.dart';

class Competition {
  Competition({
    required this.id,
    required this.title,
    required this.initialDate,
    required this.competitors,
    this.invitations,
  }) {
    if (competitors.isNotEmpty) {
      competitors.sort((a, b) => b.score.compareTo(a.score));
    }
  }

  final String id;
  String title;
  final DateTime initialDate;
  final List<Competitor> competitors;
  final List<String>? invitations;

  Competitor getMyCompetitor(String userUid) =>
      competitors.firstWhere((element) => element.uid == userUid);

  String listCompetitors() => competitors.join(', ');
}
