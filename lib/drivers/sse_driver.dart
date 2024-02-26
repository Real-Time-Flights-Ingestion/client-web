@JS()
library callable_function;

import 'dart:async';

import 'package:js/js.dart';
import 'package:logging/logging.dart';

import '../models/sse_model.dart';

/// Allows assigning a function to be callable from `window.manageServerSideEvent(event)`
@JS('manageServerSideEvent')
external set _manageServerSideEvent(void Function(dynamic event) f);

/// Allows calling the openSSEStream js function from dart
@JS('openSSEStream')
external void _openSSEStream(String connectionUrl);

/// Allows calling the closeSSEStream js function from dart
@JS('closeSSEStream')
external void _closeSSEStream();

/// Makes the js function actually callable
///
/// The f parameter is the function that will be called after manageServerSideEvent(event) is called in js.
void setCallbackFunction(void Function(dynamic event) f) {
  _manageServerSideEvent = allowInterop(f);
}

/// Singleton class that manages the events stream used by the UI
///
class SSEDriver {
  static SSEDriver get instance => _instance;

  factory SSEDriver() => _instance;

  static final SSEDriver _instance = SSEDriver._internal();

  static final Logger _logger = Logger("SSEDriver");

  /// The stream controller is used for adding events to the eventStream
  StreamController<ServerSideEvent> _controller =
      StreamController(onListen: () {
    _logger.fine("SSE controller is been listened to");
  });

  /// Internal constructor (which is called by the static _instance field)
  ///
  /// It calls the setCallbackFunction with the callback that adds an event
  /// to the streamController
  SSEDriver._internal() {
    _logger.info("SSEStream class initializing...");
    setCallbackFunction(_addEventToStream);
  }

  /// Prints the new event on console and adds the event to the streamController
  void _addEventToStream(dynamic event) {
    _logger.fine("New SSE received", event);
    if (!_controller.isClosed) {
      _controller.add(ServerSideEvent(data: event.toString()));
    }
  }

  /// The exposed event stream
  Stream<ServerSideEvent> get eventStream => _controller.stream;

  void openStream({required String connectionUrl}) async {
    if (_controller.isClosed) _resetController();
    try {
      _openSSEStream("//$connectionUrl");
      _logger.fine("Opening source stream");
    } catch (e, s) {
      _logger.warning("Exception caught during openStream()", e, s);
    }
  }

  Future<void> pauseStream() async {
    try {
      _closeSSEStream();
      _logger.fine("Pausing source stream");
    } catch (e, s) {
      _logger.warning("Exception caught during pauseStream()", e, s);
    }
  }

  /// Utility function that closes the stream on dart and js sides
  Future<void> closeStream() async {
    try {
      _closeSSEStream();
      await _controller.close();
      _logger.fine("Source stream closed");
    } catch (e, s) {
      _logger.warning("Exception caught during closeStream()", e, s);
    }
  }

  void _resetController() {
    _controller = StreamController(onListen: () {
      _logger.fine("SSE controller is been listened to");
    });
  }
}
