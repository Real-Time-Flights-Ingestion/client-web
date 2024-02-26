import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rtfi_client_web/models/airports_icao_enum.dart';

import '../repositories/sse_repository.dart';

part 'sse_settings_state.dart';

class SseSettingsCubit extends Cubit<SseSettingsState> {
  SseSettingsCubit() : super(SseSettingsInitial());
  static final SSERepository _sseRepository = SSERepository();

  static final Logger _logger = Logger("SseSettingsCubit");

  void playSourceStream() {
    try {
      _sseRepository.playSourceStream();
      emit(SseSettingsPlayingStream());
    } catch (e, s) {
      _logger.warning("Error occurred during playSourceStream()", e, s);
    }
  }

  void pauseSourceStream() {
    try {
      _sseRepository.pauseSourceStream();
      emit(SseSettingsPausedStream());
    } catch (e, s) {
      _logger.warning("Error occurred during pauseSourceStream()", e, s);
    }
  }

  void clearCache() {
    try {
      _sseRepository.clearCache();
    } catch (e, s) {
      _logger.warning("Error occurred during clearCache()", e, s);
    }
  }

  void changeAirport({required AirportsIcao icao}) async {
    try {
      emit(SseSettingsPausedStream());
      await _sseRepository.changeStreamUri(icao: icao.name.toLowerCase());
      emit(SseSettingsPlayingStream());
    } catch (e, s) {
      _logger.warning("Error occurred during changeAirport()", e, s);
    }
  }

  @override
  Future<void> close() async {
    try {
      await _sseRepository.pauseSourceStream();
    } catch (e, s) {
      _logger.warning("Error occurred during close()", e, s);
    }
    return super.close();
  }
}
