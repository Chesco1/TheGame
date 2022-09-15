import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/train/train_info.dart';

enum TrackTileType {
  none(0),
  straight(4),
  weakCurve(0),
  strongCurve(8);

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

enum Direction {
  top(0),
  topRight(1),
  right(2),
  bottomRight(3),
  bottom(4),
  bottomLeft(5),
  left(6),
  topLeft(7);

  final int eighthTurnsFromTop;

  const Direction(this.eighthTurnsFromTop);

  static Direction? getFromEighthTurnsFromTop(int eighthTurns) {
    switch (eighthTurns % 8) {
      case 0:
        return Direction.top;
      case 1:
        return Direction.topRight;
      case 2:
        return Direction.right;
      case 3:
        return Direction.bottomRight;
      case 4:
        return Direction.bottom;
      case 5:
        return Direction.bottomLeft;
      case 6:
        return Direction.left;
      case 7:
        return Direction.topLeft;
      default:
        return null; // should not be possible
    }
  }
}

@immutable
class TrackTileStackBlueprint {
  final int columnIndex;
  final int rowIndex;
  final List<SingleTrackTileBlueprint> singlePartBlueprints;

  const TrackTileStackBlueprint({
    required this.columnIndex,
    required this.rowIndex,
    this.singlePartBlueprints = const [
      SingleTrackTileBlueprint(),
    ],
  });

  TrackTileStackBlueprint copyWith({
    int? newColumnIndex,
    int? newRowIndex,
    int? trackTileIndexToEdit,
    TrackTileType? newType,
    int? newEighthTurns,
    TrackColor? newColor,
  }) {
    return TrackTileStackBlueprint(
      columnIndex: newColumnIndex ?? columnIndex,
      rowIndex: newRowIndex ?? rowIndex,
      singlePartBlueprints: [
        for (int i = 0; i < singlePartBlueprints.length; i++)
          if (i == trackTileIndexToEdit)
            singlePartBlueprints[i].copyWith(
              newType: newType,
              newEighthTurns: newEighthTurns,
              newColor: newColor,
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
  final int eighthTurns;
  final TrackColor color;

  const SingleTrackTileBlueprint({
    this.type = TrackTileType.none,
    this.eighthTurns = 0,
    this.color = TrackColor.none,
  });

  SingleTrackTileBlueprint copyWith({
    TrackTileType? newType,
    int? newEighthTurns,
    TrackColor? newColor,
  }) {
    return SingleTrackTileBlueprint(
      type: newType ?? type,
      eighthTurns: newEighthTurns ?? eighthTurns,
      color: newColor ?? color,
    );
  }

  List<Direction?> getEntrancePoints() {
    if (type == TrackTileType.straight) {
      return [
        Direction.getFromEighthTurnsFromTop(
          Direction.top.eighthTurnsFromTop + eighthTurns,
        ),
        Direction.getFromEighthTurnsFromTop(
          Direction.bottom.eighthTurnsFromTop + eighthTurns,
        ),
      ];
    } else if (type == TrackTileType.strongCurve) {
      return [
        Direction.getFromEighthTurnsFromTop(
          Direction.top.eighthTurnsFromTop + eighthTurns,
        ),
        Direction.getFromEighthTurnsFromTop(
          Direction.right.eighthTurnsFromTop + eighthTurns,
        ),
      ];
    }
    return [null, null];
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
                eighthTurns: 0,
                color: TrackColor.none,
              ),
              SingleTrackTileBlueprint(
                type: TrackTileType.straight,
                eighthTurns: 2,
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
                eighthTurns: 2,
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
                eighthTurns: 0,
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
                eighthTurns: 3,
                color: TrackColor.blue,
              ),
              SingleTrackTileBlueprint(
                type: TrackTileType.strongCurve,
                eighthTurns: 2,
                color: TrackColor.green,
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
    int? newEighthTurns,
    TrackColor? newColor,
  }) {
    state = [
      for (final blueprint in state)
        if (blueprint.columnIndex == columnIndex &&
            blueprint.rowIndex == rowIndex)
          blueprint.copyWith(
            trackTileIndexToEdit: trackTileIndex,
            newType: newType,
            newEighthTurns: newEighthTurns,
            newColor: newColor,
          )
        else
          blueprint,
    ];
  }

  void addTrackRow(Direction direction) {
    int currentRowCount = getTrackRowCount();
    if (direction == Direction.bottom) {
      state = [
        ...state,
        for (int i = 0; i < getTrackColumnCount(); i++)
          TrackTileStackBlueprint(
            columnIndex: i,
            rowIndex: currentRowCount,
          )
      ];
    } else {
      state = [
        for (final blueprint in state)
          blueprint.copyWith(
            newRowIndex: blueprint.rowIndex + 1,
          ),
        for (int i = 0; i < getTrackColumnCount(); i++)
          TrackTileStackBlueprint(
            columnIndex: i,
            rowIndex: 0,
          ),
      ];
    }
  }

  void removeTrackRow(Direction direction) {
    int currentRowCount = getTrackRowCount();

    if (currentRowCount > 1) {
      if (direction == Direction.bottom) {
        state = [
          for (final blueprint in state
              .where((blueprint) => blueprint.rowIndex < currentRowCount - 1))
            blueprint,
        ];
      } else {
        state = [
          for (final blueprint
              in state.where((blueprint) => blueprint.rowIndex > 0))
            blueprint.copyWith(newRowIndex: blueprint.rowIndex - 1),
        ];
      }
    }
  }

  void addTrackColumn(Direction direction) {
    int currentColumnCount = getTrackColumnCount();

    if (direction == Direction.right) {
      state = [
        ...state,
        for (int i = 0; i < getTrackRowCount(); i++)
          TrackTileStackBlueprint(
            columnIndex: currentColumnCount,
            rowIndex: i,
          )
      ];
    } else {
      state = [
        for (final blueprint in state)
          blueprint.copyWith(
            newColumnIndex: blueprint.columnIndex + 1,
          ),
        for (int i = 0; i < getTrackRowCount(); i++)
          TrackTileStackBlueprint(
            columnIndex: 0,
            rowIndex: i,
          )
      ];
    }
  }

  void removeTrackColumn(Direction direction) {
    int currentColumnCount = getTrackColumnCount();

    if (currentColumnCount > 1) {
      if (direction == Direction.right) {
        state = [
          for (final blueprint in state.where(
              (blueprint) => blueprint.columnIndex < currentColumnCount - 1))
            blueprint,
        ];
      } else {
        state = [
          for (final blueprint
              in state.where((blueprint) => blueprint.columnIndex > 0))
            blueprint.copyWith(newColumnIndex: blueprint.columnIndex - 1),
        ];
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

final trackBlueprintProvider =
    StateNotifierProvider<TrackNotifier, List<TrackTileStackBlueprint>>((ref) {
  return TrackNotifier();
});
