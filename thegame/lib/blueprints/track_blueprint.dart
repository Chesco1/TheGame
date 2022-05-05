import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TrackPartType { straight, strongCurve, weakCurve }
enum TrackColor { none, red, green, blue }

@immutable
class TrackBlockBlueprint {
  final int trackBlockIndex;
  final int columnIndex;
  final int rowIndex;
  final List<SingleTrackPartBlueprint> singlePartBlueprints;

  const TrackBlockBlueprint({
    required this.trackBlockIndex,
    required this.columnIndex,
    required this.rowIndex,
    required this.singlePartBlueprints,
  });
}

////////////////////////////////////////////////////////////////////////////////

@immutable
class SingleTrackPartBlueprint {
  final int trackPartIndex;
  final TrackPartType type;
  final int typeIndex;
  final TrackColor color;

  const SingleTrackPartBlueprint({
    required this.trackPartIndex,
    required this.type,
    required this.typeIndex,
    required this.color,
  });
}

////////////////////////////////////////////////////////////////////////////////

class TrackNotifier extends StateNotifier<List<TrackBlockBlueprint>> {
  TrackNotifier() : super([]);
}

////////////////////////////////////////////////////////////////////////////////

final trackBlueprintProvider =
    StateNotifierProvider<TrackNotifier, List<TrackBlockBlueprint>>((ref) {
  return TrackNotifier();
});
