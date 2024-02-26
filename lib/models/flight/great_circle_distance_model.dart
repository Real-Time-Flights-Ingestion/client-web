part of 'flight_model.dart';

@immutable
class GreatCircleDistance extends CanBeUnknown {
  final double meter;
  final double km;
  final double mile;
  final double nm;
  final double feet;

  const GreatCircleDistance(
      {required this.meter,
      required this.km,
      required this.mile,
      required this.nm,
      required this.feet})
      : super();

  Map<String, dynamic> toJson() => <String, dynamic>{
        "meter": meter,
        "km": km,
        "mile": mile,
        "nm": nm,
        "feet": feet,
      };

  factory GreatCircleDistance.fromJson(Map<String, dynamic> json) {
    return GreatCircleDistance(
      meter: json["meter"] ?? 0.0,
      km: json["km"] ?? 0.0,
      mile: json["mile"] ?? 0.0,
      nm: json["nm"] ?? 0.0,
      feet: json["feet"] ?? 0.0,
    );
  }

  const GreatCircleDistance.unknown()
      : meter = 0.0,
        km = 0.0,
        mile = 0.0,
        nm = 0.0,
        feet = 0.0,
        super(unknown: true);

  @override
  String toString() {
    return 'GreatCircleDistance{meter: $meter, km: $km, mile: $mile, nm: $nm, feet: $feet}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GreatCircleDistance &&
          runtimeType == other.runtimeType &&
          meter == other.meter &&
          km == other.km &&
          mile == other.mile &&
          nm == other.nm &&
          feet == other.feet;

  @override
  int get hashCode =>
      meter.hashCode ^
      km.hashCode ^
      mile.hashCode ^
      nm.hashCode ^
      feet.hashCode;
}
