import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../models/flight_event.dart';

@immutable
class FlightsApi {
  static const FlightsApi _instance = FlightsApi._();

  factory FlightsApi() => _instance;

  const FlightsApi._();

  static final Logger _logger = Logger("FlightsApi");

  Future<List<FlightEvent>> getInitialFlightEvents(
      {required String connectionUri}) async {
    try {
      http.Response response =
          await http.get(Uri.parse("http://$connectionUri"));
      _logger.info(
          "htpp request: ${response.statusCode} | ${response.reasonPhrase}");
      List<dynamic> body = List.from(jsonDecode(response.body));
      List<Map<String, dynamic>> deserializedBody = body
          .map((e) => <String, dynamic>{
                "flight": Map<String, dynamic>.from(
                    jsonDecode(Map<String, dynamic>.from(e)["value"]))
              })
          .toList();
      _logger.info("Response body", deserializedBody);
      return List.from(deserializedBody.map((e) => FlightEvent.fromJson(e)));
    } catch (e, s) {
      _logger.warning("Error requesting last flights", e, s);
      return [];
    }
  }
}
