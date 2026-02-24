import 'package:birdify/models/observation.dart';
import 'package:flutter/foundation.dart';

/// In-memory store for the current session's saved observations.
/// Backed by a [ValueNotifier] so UI widgets can listen reactively.
class ObservationsService {
  ObservationsService._();

  static final _notifier = ValueNotifier<List<Observation>>(const []);

  /// Listenable list of all saved observations (most-recent first).
  static ValueListenable<List<Observation>> get notifier => _notifier;

  static List<Observation> get observations => _notifier.value;

  /// Add a new observation and notify listeners.
  static void add(Observation obs) {
    _notifier.value = [obs, ..._notifier.value];
  }

  /// Remove an observation by [id] and notify listeners.
  static void remove(String id) {
    _notifier.value =
        _notifier.value.where((o) => o.id != id).toList();
  }
}
