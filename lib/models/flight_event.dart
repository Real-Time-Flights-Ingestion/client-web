import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'flight/flight_model.dart';
import 'sse_model.dart';

@immutable
class FlightEvent {
  final Flight flight;
  final DateTime timestamp;

  static final Logger _logger = Logger("FlightEventModel");

  FlightEvent({required this.flight, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.timestamp().toLocal();

  Map<String, dynamic> toJson() => <String, dynamic>{
        "flight": flight.toJson(),
        "timestamp": timestamp,
      };

  factory FlightEvent.fromJson(Map<String, dynamic> json) {
    try {
      return FlightEvent(
        flight: Flight.fromJson(Map<String, dynamic>.from(json["flight"])),
      );
    } catch (e, s) {
      _logger.warning(
          "Something went wrong during construction of FlightEvent from json",
          e,
          s);
      return FlightEvent(flight: Flight.unknown());
    }
  }

  factory FlightEvent.fromSse(ServerSideEvent event) {
    try {
      Map<String, dynamic> jsonData =
          Map<String, dynamic>.from(<String, dynamic>{
        "flight": jsonDecode(
            Map<String, dynamic>.from(jsonDecode(event.data))["value"])
      });
      return FlightEvent.fromJson(jsonData);
    } catch (e, s) {
      _logger.warning(
          "Something went wrong during construction of FlightEvent from SSE event",
          e,
          s);
      return FlightEvent(flight: Flight.unknown());
    }
  }

  @override
  String toString() {
    return 'FlightEvent{flight: $flight, timestamp: ${timestamp.toIso8601String()}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlightEvent &&
          runtimeType == other.runtimeType &&
          flight == other.flight &&
          timestamp == other.timestamp;

  @override
  int get hashCode => flight.hashCode ^ timestamp.hashCode;
}
