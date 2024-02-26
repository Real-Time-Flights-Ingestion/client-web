import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'unknown_model.dart';

@immutable
class Airport extends CanBeUnknown {
  final String icao;
  final String iata;
  final String name;
  final String shortName;
  final String municipalityName;
  final String countryCode;

  final AirportLocation location;

  const Airport(
      {required this.icao,
      required this.iata,
      required this.name,
      required this.shortName,
      required this.municipalityName,
      required this.countryCode,
      required this.location});

  Map<String, dynamic> toJson() => <String, dynamic>{
        "location": location.toJson(),
        "icao": icao,
        "iata": iata,
        "name": name,
        "shortName": shortName,
        "municipalityName": municipalityName,
        "countryCode": countryCode
      };

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      location: AirportLocation.fromJson(
        Map<String, dynamic>.from(
          json["location"] ?? const AirportLocation.unknown().toJson(),
        ),
      ),
      icao: json["icao"] ?? "unknown",
      iata: json["iata"] ?? "unknown",
      name: json["name"] ?? "unknown",
      shortName: json["shortName"] ?? "unknown",
      municipalityName: json["municipalityName"] ?? "unknown",
      countryCode: json["countryCode"] ?? "??",
    );
  }

  const Airport.unknown()
      : location = const AirportLocation.unknown(),
        icao = "unknown",
        iata = "unknown",
        name = "unknown",
        shortName = "unknown",
        municipalityName = "unknown",
        countryCode = "??",
        super(unknown: true);

  @override
  String toString() {
    return 'Airport{icao: $icao, iata: $iata, name: $name, '
        'shortName: $shortName, municipalityName: $municipalityName, '
        'countryCode: $countryCode, location: $location}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Airport &&
          runtimeType == other.runtimeType &&
          icao == other.icao &&
          iata == other.iata &&
          name == other.name &&
          shortName == other.shortName &&
          municipalityName == other.municipalityName &&
          countryCode == other.countryCode &&
          location == other.location;

  @override
  int get hashCode =>
      icao.hashCode ^
      iata.hashCode ^
      name.hashCode ^
      shortName.hashCode ^
      municipalityName.hashCode ^
      countryCode.hashCode ^
      location.hashCode;
}

@immutable
class AirportLocation extends CanBeUnknown {
  final double lat;
  final double lon;

  const AirportLocation({required this.lat, required this.lon});

  MapLatLng get toMapLatLng => MapLatLng(lat, lon);

  static final Logger _logger = Logger("AirportLocationModel");

  @override
  String toString() {
    return 'AirportLocation{lat: $lat, lon: $lon}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirportLocation &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          lon == other.lon;

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "lat": lat,
        "lon": lon,
      };

  factory AirportLocation.fromJson(Map<String, dynamic> json) {
    try {
      return AirportLocation(
          lat: (double.parse(json["lat"].toString())),
          lon: (double.parse(json["lon"].toString())));
    } catch (e, s) {
      _logger.warning(
          "Something went wrong during construction of AirportLocation from json",
          e,
          s);
      return const AirportLocation.unknown();
    }
  }

  const AirportLocation.unknown()
      : lat = 0.0,
        lon = 0.0,
        super(unknown: true);
}
