import 'package:habit/utils/enums.dart';

class Progress {
  final ProgressEnum type;
  double progress;
  final String unit;
  final int goal;

  Progress({this.type, this.progress, this.unit, this.goal});

  factory Progress.fromJson(Map<String, dynamic> json) => new Progress(
      type: ProgressEnum.values[json["type"]], progress: json["progress"], unit: json["unit"], goal: json["goal"]);

  Map<String, dynamic> toJson() => {
        "type": type.index,
        "progress": progress,
        "unit": unit,
        "goal": goal,
      };
}
