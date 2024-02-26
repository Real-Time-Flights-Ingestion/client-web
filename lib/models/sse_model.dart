import 'package:meta/meta.dart';

/// Custom event class
@immutable
class ServerSideEvent {
  final String data;

  const ServerSideEvent({required this.data});
}
