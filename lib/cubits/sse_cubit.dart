import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../models/flight_event.dart';
import '../repositories/sse_repository.dart';

part 'sse_state.dart';

class SseCubit extends Cubit<SseState> {
  SseCubit()
      : super(SseInitialState(
          Map.from(_sseRepository.eventsCache),
        ));

  static final SSERepository _sseRepository = SSERepository();

  StreamSubscription<FlightEvent>? _streamSubscription;

  final Logger _logger = Logger("SseCubit");

  void playStream() {
    try {
      _streamSubscription ??= _sseRepository.events.listen((event) {
        _logger.fine("RealTimeUI Event", event);
        state.events[event.flight.number] = event;
        emit(SseListeningState(state.events));
      });
      _streamSubscription!.resume();
      emit(SseListeningState(state.events));
    } catch (e, s) {
      _logger.warning("Error occurred during playStream()", e, s);
    }
  }

  void pauseStream() {
    try {
      if (_streamSubscription == null) return;
      _streamSubscription!.pause();
      emit(SsePausedState(state.events));
    } catch (e, s) {
      _logger.warning("Error occurred during pauseStream()", e, s);
    }
  }

  Future<void> restartStream() async {
    try {
      if (_streamSubscription == null) return;
      _streamSubscription!.pause();
      state.events.clear();
      emit(SseInitialState(state.events));
    } catch (e, s) {
      _logger.warning("Error occurred during restartStream()", e, s);
    }
  }

  @override
  Future<void> close() {
    try {
      return _streamSubscription?.cancel().then((value) => super.close()) ??
          super.close();
    } catch (e, s) {
      _logger.warning("Error occurred during close()", e, s);
      return super.close();
    }
  }
}
