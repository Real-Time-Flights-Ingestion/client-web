part of 'flight_model.dart';

@immutable
class Arrival extends CanBeUnknown {
  final String baggageBelt;
  final String terminal;
  final String gate;
  final Airport airport;
  final ScheduledTime scheduledTime;
  final RevisedTime revisedTime;
  final RunwayTime runwayTime;
  final List<Quality> quality;

  const Arrival({
    required this.terminal,
    required this.baggageBelt,
    required this.gate,
    required this.airport,
    required this.scheduledTime,
    required this.revisedTime,
    required this.runwayTime,
    required this.quality,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        "terminal": terminal,
        "baggageBelt": baggageBelt,
        "gate": gate,
        "airport": airport.toJson(),
        "scheduledTime": scheduledTime.toJson(),
        "revisedTime": revisedTime.toJson(),
        "runwayTime": runwayTime.toJson(),
        "quality": quality.map((e) => e.name),
      };

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      terminal: json["terminal"] ?? "unknown",
      baggageBelt: json["baggageBelt"] ?? "unknown",
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
          : RunwayTime.fromJson(Map<String, dynamic>.from(json["runwayTime"])),
      quality: (json["quality"] == null || List.from(json["quality"]).isEmpty)
          ? <Quality>[Quality.unknown]
          : List.from(json["quality"])
              .map(
                (e) => Quality.values.singleWhere(
                    (element) => element.name == e,
                    orElse: () => Quality.unknown),
              )
              .toList(),
    );
  }

  const Arrival.unknown()
      : terminal = "unknown",
        baggageBelt = "unknown",
        gate = "unknown",
        airport = const Airport.unknown(),
        scheduledTime = const ScheduledTime.unknown(),
        revisedTime = const RevisedTime.unknown(),
        runwayTime = const RunwayTime.unknown(),
        quality = const [Quality.unknown],
        super(unknown: true);

  @override
  String toString() {
    return 'Arrival{terminal: $terminal,baggageBelt: $baggageBelt, gate: $gate, airport: $airport, scheduledTime: $scheduledTime, revisedTime: $revisedTime,runwayTime: $runwayTime, quality: ${quality.map((e) => e.name)}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Arrival &&
          runtimeType == other.runtimeType &&
          terminal == other.terminal &&
          baggageBelt == other.baggageBelt &&
          gate == other.gate &&
          airport == other.airport &&
          scheduledTime == other.scheduledTime &&
          revisedTime == other.revisedTime &&
          runwayTime == other.runwayTime &&
          quality == other.quality;

  @override
  int get hashCode =>
      terminal.hashCode ^
      baggageBelt.hashCode ^
      gate.hashCode ^
      airport.hashCode ^
      scheduledTime.hashCode ^
      revisedTime.hashCode ^
      runwayTime.hashCode ^
      quality.hashCode;
}
