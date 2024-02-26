part of 'sse_settings_cubit.dart';

@immutable
abstract class SseSettingsState {
  AirportsIcao get currentIcao {
    if (AirportsIcao.values
        .map((e) => e.name.toLowerCase())
        .contains(SSERepository().currentIcao.toLowerCase())) {
      return AirportsIcao.values.singleWhere((element) =>
          element.name.toLowerCase() ==
          SSERepository().currentIcao.toLowerCase());
    }
    return AirportsIcao.ellx;
  }
}

class SseSettingsInitial extends SseSettingsState {}

class SseSettingsPausedStream extends SseSettingsState {}

class SseSettingsPlayingStream extends SseSettingsState {}
