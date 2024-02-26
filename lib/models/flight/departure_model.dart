part of 'flight_model.dart';

@immutable
class Departure extends CanBeUnknown {
  final String terminal;
  final String gate;
  final Airport airport;
  final ScheduledTime scheduledTime;
  final RevisedTime revisedTime;
  final RunwayTime runwayTime;
  final List<Quality> quality;
  final String checkInDesk;

  const Departure({
    required this.terminal,
    required this.gate,
    required this.airport,
    required this.scheduledTime,
    required this.revisedTime,
    required this.runwayTime,
    required this.quality,
    required this.checkInDesk,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        "terminal": terminal,
        "gate": gate,
        "airport": airport.toJson(),
        "scheduledTime": scheduledTime.toJson(),
        "revisedTime": revisedTime.toJson(),
        "runwayTime": runwayTime.toJson(),
        "checkInDesk": checkInDesk,
        "quality": quality.map((e) => e.name),
      };

  factory Departure.fromJson(Map<String, dynamic> json) {
    return Departure(
        terminal: json["terminal"] ?? "unknown",
        gate: json["gate"] ?? "unknown",
        airport: json["airport"] == null
            ? const Airport.unknown()
            : Airport.fromJson(Map<String, dynamic>.from(json["airport"])),
        scheduledTime: json["scheduledTime"] == null
            ? const ScheduledTime.unknown()
            : ScheduledTime.fromJson(
                Map<String, dynamic>.from(json["scheduledTime"])),
        revisedTime: json["revisedTime"] == null
            ? const RevisedTime.unknown()
            : RevisedTime.fromJson(
                Map<String, dynamic>.from(json["revisedTime"])),
        runwayTime: json["runwayTime"] == null
            ? const RunwayTime.unknown()
            : RunwayTime.fromJson(
                Map<String, dynamic>.from(json["runwayTime"])),
        quality: (json["quality"] == null || List.from(json["quality"]).isEmpty)
            ? <Quality>[Quality.unknown]
            : QualityDeserialization.fromStringList(List.from(json["quality"])),
        checkInDesk: json["checkInDesk"] ?? "unknown");
  }

  const Departure.unknown()
      : terminal = "unknown",
        gate = "unknown",
        airport = const Airport.unknown(),
        scheduledTime = const ScheduledTime.unknown(),
        revisedTime = const RevisedTime.unknown(),
        runwayTime = const RunwayTime.unknown(),
        quality = const [Quality.unknown],
        checkInDesk = "unknown",
        super(unknown: true);

  @override
  String toString() {
    return 'Departure{terminal: $terminal, gate: $gate, airport: $airport, scheduledTime: $scheduledTime, revisedTime: $revisedTime, runwayTime: $runwayTime, quality: ${quality.map((e) => e.name)}, checkInDesk: $checkInDesk';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Departure &&
          runtimeType == other.runtimeType &&
          terminal == other.terminal &&
          gate == other.gate &&
          airport == other.airport &&
          scheduledTime == other.scheduledTime &&
          revisedTime == other.revisedTime &&
          runwayTime == other.runwayTime &&
          quality == other.quality &&
          checkInDesk == other.checkInDesk;

  @override
  int get hashCode =>
      terminal.hashCode ^
      gate.hashCode ^
      airport.hashCode ^
      scheduledTime.hashCode ^
      revisedTime.hashCode ^
      runwayTime.hashCode ^
      checkInDesk.hashCode ^
      quality.hashCode;
}
