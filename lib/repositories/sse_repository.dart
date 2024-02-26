import 'dart:async';

import 'package:logging/logging.dart';
import 'package:rtfi_client_web/models/airports_icao_enum.dart';

import '../drivers/flights_api.dart';
import '../drivers/sse_driver.dart';
import '../models/flight_event.dart';
import '../models/sse_model.dart';

class SSERepository {
  static final SSERepository _instance = SSERepository._();

  static final FlightsApi _flightsApi = FlightsApi();

  factory SSERepository() => _instance;

  static final Logger _logger = Logger("SSERepository");

  String _getConnectionString() =>
      "rtfi.servehttp.com:5555/airport/$_currentIcao/flights";

  String _currentIcao = AirportsIcao.ellx.name.toLowerCase().trim();

  String get currentIcao => _currentIcao;

  SSERepository._() {
    _sseDriver.pauseStream().then((_) {
      _subscription = _sseDriver.eventStream.listen((event) {
        FlightEvent deserializedEvent = FlightEvent.fromSse(event);
        _controller.add(deserializedEvent);
        _eventsCache[deserializedEvent.flight.number] = deserializedEvent;
        _logger.fine("Deserialized event", deserializedEvent.toString());
      });
      _subscription.onError((err) {
        _logger.warning("An error occurred on the sseDriver eventStream.", err,
            StackTrace.current);
      });
      _flightsApi
          .getInitialFlightEvents(connectionUri: _getConnectionString())
          .then((olderEvents) {
        for (FlightEvent event in olderEvents) {
          _controller.add(event);
          _eventsCache[event.flight.number] = event;
          _logger.fine("Preloaded event", event.toString());
        }
      });
    });
  }

  static final SSEDriver _sseDriver = SSEDriver();

  final Map<String, FlightEvent> _eventsCache = {};

  Map<String, FlightEvent> get eventsCache => Map.unmodifiable(_eventsCache);

  late StreamSubscription<ServerSideEvent> _subscription;

  void playSourceStream() {
    try {
      _subscription.resume();
      _sseDriver.openStream(connectionUrl: _getConnectionString());
      _logger.fine("Playing SourceStream on airport $_currentIcao");
    } catch (e, s) {
      _logger.warning("An error occurred during playSourceStream()", e, s);
    }
  }

  Future<void> pauseSourceStream() async {
    try {
      _subscription.pause();
      await _sseDriver.pauseStream();
      _logger.fine("Pausing SourceStream");
    } catch (e, s) {
      _logger.warning("An error occurred during pauseSourceStream()", e, s);
    }
  }

  Future<void> closeSourceStream() async {
    try {
      _subscription.cancel();
      await _sseDriver.closeStream();
    } catch (e, s) {
      _logger.warning("An error occurred during closeSourceStream()", e, s);
    }
  }

  void clearCache() {
    _eventsCache.clear();
    _logger.fine("Events cache cleared");
  }

  static final StreamController<FlightEvent> _controller = StreamController();

  Stream<FlightEvent> get events => _controller.stream.asBroadcastStream();

  Future<void> changeStreamUri({required String icao}) async {
    await _sseDriver.closeStream();
    await _subscription.cancel();
    _eventsCache.clear();
    _currentIcao = icao.toLowerCase().trim();
    _sseDriver.openStream(connectionUrl: _getConnectionString());
    _subscription = _sseDriver.eventStream.listen((event) {
      FlightEvent deserializedEvent = FlightEvent.fromSse(event);
      _controller.add(deserializedEvent);
      _eventsCache[deserializedEvent.flight.number] = deserializedEvent;
      _logger.fine("Deserialized event", deserializedEvent.toString());
    });
    _subscription.onError((err) {
      _logger.warning("An error occurred on the sseDriver eventStream.", err,
          StackTrace.current);
    });
    _flightsApi
        .getInitialFlightEvents(connectionUri: _getConnectionString())
        .then((olderEvents) {
      for (FlightEvent event in olderEvents) {
        _controller.add(event);
        _eventsCache[event.flight.number] = event;
        _logger.fine("Preloaded event", event.toString());
      }
    });
  }
}
