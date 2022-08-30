import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TrackPartType { straight, weakCurve, strongCurve }

enum TrackColor { none, red, green, blue }

@immutable
class TrackTileBlueprint {
  final int columnIndex;
  final int rowIndex;
  final List<SingleTrackPartBlueprint> singlePartBlueprints;

  const TrackTileBlueprint({
    required this.columnIndex,
    required this.rowIndex,
    required this.singlePartBlueprints,
  });
}

////////////////////////////////////////////////////////////////////////////////

@immutable
class SingleTrackPartBlueprint {
  final TrackPartType type;

  /// Specifies the exact trackPart from this [TrackPartType]
  final int typeIndex;
  final TrackColor color;

  const SingleTrackPartBlueprint({
    required this.type,
    required this.typeIndex,
    required this.color,
  });
}

////////////////////////////////////////////////////////////////////////////////

class TrackNotifier extends StateNotifier<List<TrackTileBlueprint>> {
  TrackNotifier()
      : super([
          const TrackTileBlueprint(
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
          const TrackTileBlueprint(
            columnIndex: 1,
            rowIndex: 0,
            singlePartBlueprints: [
              SingleTrackPartBlueprint(
                type: TrackPartType.strongCurve,
                typeIndex: 2,
                color: TrackColor.red,
              ),
            ],
          ),
          const TrackTileBlueprint(
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
          const TrackTileBlueprint(
            columnIndex: 1,
            rowIndex: 1,
            singlePartBlueprints: [
              SingleTrackPartBlueprint(
                type: TrackPartType.strongCurve,
                typeIndex: 3,
                color: TrackColor.blue,
              ),
            ],
          ),
        ]);

  int getTrackTileIndex(int columnIndex, int rowIndex) {
    int i = 0;

    for (var blueprint in state) {
      if (blueprint.columnIndex == columnIndex &&
          blueprint.rowIndex == rowIndex) {
        return i;
      }
      i++;
    }
    return -1; // should not happen
  }

  int getTrackRowCount() {
    int highest = 0;

    for (TrackTileBlueprint blueprint in state) {
      if (blueprint.rowIndex >= highest) {
        highest = blueprint.rowIndex + 1;
      }
    }
    return highest;
  }

  int getTrackColumnCount() {
    int highest = 0;

    for (TrackTileBlueprint blueprint in state) {
      if (blueprint.columnIndex >= highest) {
        highest = blueprint.columnIndex + 1;
      }
    }
    return highest;
  }
}

////////////////////////////////////////////////////////////////////////////////

final trackBlueprintProvider =
    StateNotifierProvider<TrackNotifier, List<TrackTileBlueprint>>((ref) {
  return TrackNotifier();
});
