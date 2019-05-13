import 'package:habit/utils/enums.dart';

class Progress {
  final ProgressEnum type;
  final int progress;
  final int goal;

  Progress({this.type, this.progress, this.goal});

  factory Progress.fromJson(Map<String, dynamic> json) =>
      new Progress(type: ProgressEnum.values[json["type"]], progress: json["progress"], goal: json["goal"]);

  Map<String, dynamic> toJson() => {
        "type": type.index,
        "progress": progress,
        "goal": goal,
      };
}
