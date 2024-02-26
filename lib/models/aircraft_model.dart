import 'package:meta/meta.dart';

import 'unknown_model.dart';

@immutable
class Aircraft extends CanBeUnknown {
  final String reg;
  final String modeS;
  final String model;

  const Aircraft({required this.reg, required this.modeS, required this.model});

  Map<String, dynamic> toJson() => <String, dynamic>{
        "reg": reg,
        "modeS": modeS,
        "model": model,
      };

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(
        reg: json["reg"] ?? "unknown",
        modeS: json["modeS"] ?? "unknown",
        model: json["model"] ?? "unknown");
  }

  const Aircraft.unknown()
      : reg = "unknown",
        modeS = "unknown",
        model = "unknown",
        super(unknown: true);

  @override
  String toString() {
    return 'Aircraft{reg: $reg, modeS: $modeS, model: $model}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Aircraft &&
          runtimeType == other.runtimeType &&
          reg == other.reg &&
          modeS == other.modeS &&
          model == other.model;

  @override
  int get hashCode => reg.hashCode ^ modeS.hashCode ^ model.hashCode;
}
