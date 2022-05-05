import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TrackPartType { straight, weakCurve, strongCurve }
enum TrackColor { none, red, green, blue }

@immutable
class TrackBlockBlueprint {
  final int columnIndex;
  final int rowIndex;
  final List<SingleTrackPartBlueprint> singlePartBlueprints;

  const TrackBlockBlueprint({
    required this.columnIndex,
    required this.rowIndex,
    required this.singlePartBlueprints,
  });
}

////////////////////////////////////////////////////////////////////////////////

@immutable
class SingleTrackPartBlueprint {
  final TrackPartType type;
  final int typeIndex;
  final TrackColor color;

  const SingleTrackPartBlueprint({
    required this.type,
    required this.typeIndex,
    required this.color,
  });
}

////////////////////////////////////////////////////////////////////////////////

class TrackNotifier extends StateNotifier<List<TrackBlockBlueprint>> {
  TrackNotifier()
      : super([
          const TrackBlockBlueprint(
            columnIndex: 0,
            rowIndex: 0,
            singlePartBlueprints: [
              SingleTrackPartBlueprint(
                type: TrackPartType.straight,
                typeIndex: 0,
                color: TrackColor.none,
              ),
            ],
          ),
          const TrackBlockBlueprint(
            columnIndex: 1,
            rowIndex: 0,
            singlePartBlueprints: [
              SingleTrackPartBlueprint(
                type: TrackPartType.straight,
                typeIndex: 1,
                color: TrackColor.red,
              ),
            ],
          ),
          const TrackBlockBlueprint(
            columnIndex: 0,
            rowIndex: 1,
            singlePartBlueprints: [
              SingleTrackPartBlueprint(
                type: TrackPartType.straight,
                typeIndex: 0,
                color: TrackColor.green,
              ),
            ],
          ),
          const TrackBlockBlueprint(
            columnIndex: 1,
            rowIndex: 1,
            singlePartBlueprints: [
              SingleTrackPartBlueprint(
                type: TrackPartType.straight,
                typeIndex: 1,
                color: TrackColor.blue,
              ),
            ],
          ),
        ]);
}

////////////////////////////////////////////////////////////////////////////////

final trackBlueprintProvider =
    StateNotifierProvider<TrackNotifier, List<TrackBlockBlueprint>>((ref) {
  return TrackNotifier();
});
