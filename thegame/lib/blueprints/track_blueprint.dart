import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/train/train_info.dart';

enum TrackTileType {
  none(0),
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
    this.singlePartBlueprints = const [
      SingleTrackTileBlueprint(),
    ],
  });

  TrackTileStackBlueprint copyWith({
    int? newColumnIndex,
    int? newRowIndex,
    int? trackTileIndexToEdit,
    TrackTileType? newType,
    int? newTypeIndex,
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
              newTypeIndex: newTypeIndex,
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
  final int typeIndex;
  final TrackColor color;

  const SingleTrackTileBlueprint({
    this.type = TrackTileType.none,
    this.typeIndex = 0,
    this.color = TrackColor.none,
  });

  SingleTrackTileBlueprint copyWith({
    TrackTileType? newType,
    int? newTypeIndex,
    TrackColor? newColor,
  }) {
    return SingleTrackTileBlueprint(
      type: newType ?? type,
      typeIndex: newTypeIndex ?? typeIndex,
      color: newColor ?? color,
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
            trackTileIndexToEdit: trackTileIndex,
            newType: newType,
            newTypeIndex: newTypeIndex,
            newColor: newColor,
          )
        else
          blueprint,
    ];
  }

  void addTrackRow(Direction direction) {
    int currentRowCount = getTrackRowCount();
    if (direction == Direction.down) {
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
      if (direction == Direction.down) {
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
