part of 'flight_model.dart';

@immutable
abstract class FlightTime extends CanBeUnknown {
  final DateTime? utc;
  final DateTime? local;

  const FlightTime({required this.utc, required this.local});

  Map<String, dynamic> toJson() => <String, dynamic>{
        "utc": utc?.toIso8601String() ?? "unknown",
        "local": local?.toIso8601String() ?? "unknown",
      };

  const FlightTime.unknown()
      : utc = null,
        local = null,
        super(unknown: true);

  @override
  String toString() {
    return '{utc: $utc, local: $local}';
  }
}

class ScheduledTime extends FlightTime {
  const ScheduledTime({required super.utc, required super.local});

  factory ScheduledTime.fromJson(Map<String, dynamic> json) {
    return ScheduledTime(
      utc: DateTime.tryParse(json["utc"]),
      local: DateTime.tryParse(json["local"]),
    );
  }

  const ScheduledTime.unknown() : super.unknown();

  @override
  String toString() {
    return 'ScheduledTime${super.toString()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledTime &&
          runtimeType == other.runtimeType &&
          utc == other.utc &&
          local == other.local;

  @override
  int get hashCode => utc.hashCode ^ local.hashCode;
}

class RevisedTime extends FlightTime {
  const RevisedTime({required super.utc, required super.local});

  factory RevisedTime.fromJson(Map<String, dynamic> json) {
    return RevisedTime(
      utc: DateTime.tryParse(json["utc"]),
      local: DateTime.tryParse(json["local"]),
    );
  }

  const RevisedTime.unknown() : super.unknown();

  @override
  String toString() {
    return 'RevisedTime${super.toString()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevisedTime &&
          runtimeType == other.runtimeType &&
          utc == other.utc &&
          local == other.local;

  @override
  int get hashCode => utc.hashCode ^ local.hashCode;
}

class RunwayTime extends FlightTime {
  const RunwayTime({required super.utc, required super.local});

  factory RunwayTime.fromJson(Map<String, dynamic> json) {
    return RunwayTime(
      utc: DateTime.tryParse(json["utc"]),
      local: DateTime.tryParse(json["local"]),
    );
  }

  const RunwayTime.unknown() : super.unknown();

  @override
  String toString() {
    return 'RunwayTime${super.toString()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunwayTime &&
          runtimeType == other.runtimeType &&
          utc == other.utc &&
          local == other.local;

  @override
  int get hashCode => utc.hashCode ^ local.hashCode;
}
