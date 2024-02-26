import 'package:meta/meta.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../aircraft_model.dart';
import '../airline_model.dart';
import '../airport_model.dart';
import '../unknown_model.dart';
import 'quality_enum.dart';

part 'arrival_model.dart';
part 'departure_model.dart';
part 'flight_time_model.dart';
part 'great_circle_distance_model.dart';

@immutable
class Flight extends CanBeUnknown {
  final String number;
  final String callSign;
  final String status;
  final String codeshareStatus;
  final bool isCargo;
  final GreatCircleDistance greatCircleDistance;
  final Departure departure;
  final Arrival arrival;
  final Aircraft aircraft;
  final Airline airline;

  const Flight(
      {required this.number,
      required this.callSign,
      required this.status,
      required this.codeshareStatus,
      required this.isCargo,
      required this.greatCircleDistance,
      required this.departure,
      required this.arrival,
      required this.aircraft,
      required this.airline});

  Map<String, dynamic> toJson() => <String, dynamic>{
        "number": number,
        "callSign": callSign,
        "status": status,
        "codeshareStatus": codeshareStatus,
        "isCargo": isCargo,
        "greatCircleDistance": greatCircleDistance.toJson(),
        "departure": departure.toJson(),
        "arrival": arrival.toJson(),
        "aircraft": aircraft.toJson(),
        "airline": airline.toJson()
      };

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      number: json["number"] ?? "unknown",
      callSign: json["callSign"] ?? "unknown",
      status: json["status"] ?? "unknown",
      codeshareStatus: json["codeshareStatus"] ?? "unknown",
      isCargo: json["isCargo"] ?? false,
      greatCircleDistance: json["greatCircleDistance"] == null
          ? const GreatCircleDistance.unknown()
          : GreatCircleDistance.fromJson(
              Map<String, dynamic>.from(
                json["greatCircleDistance"],
              ),
            ),
      departure: json["departure"] == null
          ? Departure.unknown()
          : Departure.fromJson(
              Map<String, dynamic>.from(
                json["departure"],
              ),
            ),
      arrival: json["arrival"] == null
          ? Arrival.unknown()
          : Arrival.fromJson(
              Map<String, dynamic>.from(
                json["arrival"],
              ),
            ),
      aircraft: json["aircraft"] == null
          ? const Aircraft.unknown()
          : Aircraft.fromJson(
              Map<String, dynamic>.from(
                json["aircraft"],
              ),
            ),
      airline: json["airline"] == null
          ? const Airline.unknown()
          : Airline.fromJson(
              Map<String, dynamic>.from(
                json["airline"],
              ),
            ),
    );
  }

  Flight.unknown()
      : number = "unknown",
        callSign = "unknown",
        status = "unknown",
        codeshareStatus = "unknown",
        isCargo = false,
        greatCircleDistance = const GreatCircleDistance.unknown(),
        departure = Departure.unknown(),
        arrival = Arrival.unknown(),
        aircraft = const Aircraft.unknown(),
        airline = const Airline.unknown(),
        super(unknown: true);

  @override
  String toString() {
    return 'Flight{number: $number, callSign: $callSign, status: $status, codeshareStatus: $codeshareStatus, isCargo: $isCargo, greatCircleDistance: $greatCircleDistance, departure: $departure, arrival: $arrival, aircraft: $aircraft, airline: $airline}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Flight &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          callSign == other.callSign &&
          status == other.status &&
          codeshareStatus == other.codeshareStatus &&
          isCargo == other.isCargo &&
          greatCircleDistance == other.greatCircleDistance &&
          departure == other.departure &&
          arrival == other.arrival &&
          aircraft == other.aircraft &&
          airline == other.airline;

  @override
  int get hashCode =>
      number.hashCode ^
      callSign.hashCode ^
      status.hashCode ^
      codeshareStatus.hashCode ^
      isCargo.hashCode ^
      greatCircleDistance.hashCode ^
      departure.hashCode ^
      arrival.hashCode ^
      aircraft.hashCode ^
      airline.hashCode;

  Duration? get departureDelay {
    if (departure.scheduledTime.isNotUnknown &&
        departure.revisedTime.isNotUnknown) {
      return departure.revisedTime.utc!
          .difference(departure.scheduledTime.utc!);
    } else {
      return null;
    }
  }

  Duration? get arrivalDelay {
    if (arrival.scheduledTime.isNotUnknown &&
        arrival.revisedTime.isNotUnknown) {
      return arrival.revisedTime.utc!.difference(arrival.scheduledTime.utc!);
    } else {
      return null;
    }
  }

  bool? get isArrived => arrival.revisedTime.isUnknown
      ? null
      : arrival.revisedTime.utc!.isBefore(DateTime.timestamp());

  bool? get isAirborne => departure.revisedTime.isUnknown
      ? null
      : departure.revisedTime.utc!.isBefore(DateTime.timestamp());

  bool? get notDepartedYet => departure.revisedTime.isUnknown
      ? null
      : departure.revisedTime.utc!.isAfter(DateTime.timestamp());

  String get fromIcao => departure.airport.icao;

  String get toIcao => arrival.airport.icao;

  MapLatLng get fromLatLng => departure.airport.location.toMapLatLng;

  MapLatLng get toLatLng => arrival.airport.location.toMapLatLng;
}
