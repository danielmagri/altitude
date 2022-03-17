class CompleteParams {
  final String habitId;
  final DateTime date;
  final bool isAdd;
  final List<DateTime>? daysDone;

  CompleteParams({
    required this.habitId,
    required this.date,
    this.isAdd = true,
    this.daysDone,
  });
}
