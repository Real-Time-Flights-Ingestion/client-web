import 'package:meta/meta.dart';

@immutable
abstract class CanBeUnknown {
  final bool _unknown;

  const CanBeUnknown({bool unknown = false}) : _unknown = unknown;

  bool get isUnknown => _unknown;

  bool get isNotUnknown => !_unknown;
}
