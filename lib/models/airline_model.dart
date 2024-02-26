import 'package:meta/meta.dart';

import 'unknown_model.dart';

@immutable
class Airline extends CanBeUnknown {
  final String icao;
  final String iata;
  final String name;

  const Airline({required this.icao, required this.iata, required this.name});

  Map<String, dynamic> toJson() => <String, dynamic>{
        "icao": icao,
        "iata": iata,
        "name": name,
      };

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
        icao: json["icao"] ?? "unknown",
        iata: json["iata"] ?? "unknown",
        name: json["name"] ?? "unknown");
  }

  const Airline.unknown()
      : icao = "unknown",
        iata = "unknown",
        name = "unknown",
        super(unknown: true);

  @override
  String toString() {
    return 'Airline{icao: $icao, iata: $iata, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Airline &&
          runtimeType == other.runtimeType &&
          icao == other.icao &&
          iata == other.iata &&
          name == other.name;

  @override
  int get hashCode => icao.hashCode ^ iata.hashCode ^ name.hashCode;
}
