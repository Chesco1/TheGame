// The state of our StateNotifier should be immutable.
// We could also use packages like Freezed to help with the implementation.
import 'package:flutter/material.dart';

@immutable
class TrackBlockBlueprint {
  const TrackBlockBlueprint(
      {required this.id, required this.description, required this.completed});

  // All properties should be `final` on our class.
  final String id;
  final String description;
  final bool completed;
}
