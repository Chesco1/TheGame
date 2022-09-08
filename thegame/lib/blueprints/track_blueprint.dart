import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TrackTileType {
  straight(2),
  weakCurve(0),
  strongCurve(4);

  final int tileAmount;
  const TrackTileType(this.tileAmount);
}

enum TrackColor {
  none(Colors.black),
  red(Colors.red),
  green(Colors.green),
  blue(Colors.blue);

  final Color paintColor;
  const TrackColor(this.paintColor);
}

@immutable
class TrackTileStackBlueprint {
  final int columnIndex;
  final int rowIndex;
  final List<SingleTrackTileBlueprint> singlePartBlueprints;

  const TrackTileStackBlueprint({
    required this.columnIndex,
    required this.rowIndex,
    this.singlePartBlueprints = const [],
  });

  TrackTileStackBlueprint copyWith(
      {required int trackTileIndex,
      TrackTileType? type,
      int? typeIndex,
      TrackColor? color}) {
    return TrackTileStackBlueprint(
      columnIndex: columnIndex,
      rowIndex: rowIndex,
      singlePartBlueprints: [
        for (int i = 0; i < singlePartBlueprints.length; i++)
          if (i == trackTileIndex)
            singlePartBlueprints[i].copyWith(
              type: type,
              typeIndex: typeIndex,
              color: color,
            )
          else
            singlePartBlueprints[i],
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

@immutable
class SingleTrackTileBlueprint {
  final TrackTileType type;

  /// Specifies the exact trackPart from this [TrackTileType]
  final int typeIndex;
  final TrackColor color;

  const SingleTrackTileBlueprint({
    required this.type,
    required this.typeIndex,
    required this.color,
  });

  SingleTrackTileBlueprint copyWith(
      {TrackTileType? type, int? typeIndex, TrackColor? color}) {
    return SingleTrackTileBlueprint(
      type: type ?? this.type,
      typeIndex: typeIndex ?? this.typeIndex,
      color: color ?? this.color,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class TrackNotifier extends StateNotifier<List<TrackTileStackBlueprint>> {
  TrackNotifier()
      : super([
          const TrackTileStackBlueprint(
            columnIndex: 0,
            rowIndex: 0,
            singlePartBlueprints: [
              SingleTrackTileBlueprint(
                type: TrackTileType.straight,
                typeIndex: 0,
                color: TrackColor.none,
              ),
            ],
          ),
          const TrackTileStackBlueprint(
            columnIndex: 1,
            rowIndex: 0,
            singlePartBlueprints: [
              SingleTrackTileBlueprint(
                type: TrackTileType.strongCurve,
                typeIndex: 2,
                color: TrackColor.red,
              ),
            ],
          ),
          const TrackTileStackBlueprint(
            columnIndex: 0,
            rowIndex: 1,
            singlePartBlueprints: [
              SingleTrackTileBlueprint(
                type: TrackTileType.straight,
                typeIndex: 0,
                color: TrackColor.green,
              ),
            ],
          ),
          const TrackTileStackBlueprint(
            columnIndex: 1,
            rowIndex: 1,
            singlePartBlueprints: [
              SingleTrackTileBlueprint(
                type: TrackTileType.strongCurve,
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

    for (TrackTileStackBlueprint blueprint in state) {
      if (blueprint.rowIndex >= highest) {
        highest = blueprint.rowIndex + 1;
      }
    }
    return highest;
  }

  int getTrackColumnCount() {
    int highest = 0;

    for (TrackTileStackBlueprint blueprint in state) {
      if (blueprint.columnIndex >= highest) {
        highest = blueprint.columnIndex + 1;
      }
    }
    return highest;
  }

  void updateTrackTileStack({
    required int columnIndex,
    required int rowIndex,
    required int trackTileIndex,
    TrackTileType? newType,
    int? newTypeIndex,
    TrackColor? newColor,
  }) {
    state = [
      for (final blueprint in state)
        if (blueprint.columnIndex == columnIndex &&
            blueprint.rowIndex == rowIndex)
          blueprint.copyWith(
            trackTileIndex: trackTileIndex,
            type: newType,
            typeIndex: newTypeIndex,
            color: newColor,
          )
        else
          blueprint,
    ];
  }
}

////////////////////////////////////////////////////////////////////////////////

final trackBlueprintProvider =
    StateNotifierProvider<TrackNotifier, List<TrackTileStackBlueprint>>((ref) {
  return TrackNotifier();
});
