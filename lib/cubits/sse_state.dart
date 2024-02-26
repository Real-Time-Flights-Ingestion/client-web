part of 'sse_cubit.dart';

@immutable
abstract class SseState {
  final Map<String, FlightEvent> events;

  const SseState(this.events);
}

class SseInitialState extends SseState {
  const SseInitialState(
    super.events,
  );
}

class SseListeningState extends SseState {
  const SseListeningState(
    super.events,
  );
}

class SsePausedState extends SseState {
  const SsePausedState(
    super.events,
  );
}
