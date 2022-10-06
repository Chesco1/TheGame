import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TrackTileType {
  none(0),
  straight(4),
  strongCurve(8),
  weakCurve(8);

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
  final List<SingleTrackTileBlueprint> singleTileBlueprints;
  final Map<Direction, List<SingleTrackTileBlueprint>> sideParts;

  const TrackTileStackBlueprint({
    required this.columnIndex,
    required this.rowIndex,
    this.singleTileBlueprints = const [
      SingleTrackTileBlueprint(),
    ],
    this.sideParts = const {},
  });

  TrackTileStackBlueprint copyWithUpdatedPosition({
    int? newColumnIndex,
    int? newRowIndex,
    Map<Direction, List<SingleTrackTileBlueprint>>? newSideParts,
  }) {
    return TrackTileStackBlueprint(
      columnIndex: newColumnIndex ?? columnIndex,
      rowIndex: newRowIndex ?? rowIndex,
      singleTileBlueprints: [
        for (final blueprint in singleTileBlueprints) blueprint,
      ],
      sideParts: newSideParts ?? sideParts,
    );
  }

  TrackTileStackBlueprint copyWithUpdatedSideParts({
    Map<Direction, List<SingleTrackTileBlueprint>>? newSideParts,
  }) {
    return TrackTileStackBlueprint(
      columnIndex: columnIndex,
      rowIndex: rowIndex,
      singleTileBlueprints: [
        for (final blueprint in singleTileBlueprints) blueprint,
      ],
      sideParts: newSideParts ?? sideParts,
    );
  }

  TrackTileStackBlueprint copyWithAddedSingleTile() {
    return TrackTileStackBlueprint(
      columnIndex: columnIndex,
      rowIndex: rowIndex,
      singleTileBlueprints: [
        for (final blueprint in singleTileBlueprints) blueprint,
        const SingleTrackTileBlueprint(),
      ],
    );
  }

  TrackTileStackBlueprint copyWithRemovedSingleTile(
    int indexTileToRemove,
  ) {
    return TrackTileStackBlueprint(
      columnIndex: columnIndex,
      rowIndex: rowIndex,
      singleTileBlueprints: [
        for (int i = 0; i < singleTileBlueprints.length; i++)
          if (i != indexTileToRemove) singleTileBlueprints[i],
      ],
    );
  }

  TrackTileStackBlueprint copyWithUpdatedSingleTile({
    int? indexSingleTileToEdit,
    TrackTileType? newType,
    int? newEighthTurns,
    TrackColor? newColor,
  }) {
    return TrackTileStackBlueprint(
      columnIndex: columnIndex,
      rowIndex: rowIndex,
      singleTileBlueprints: [
        for (int i = 0; i < singleTileBlueprints.length; i++)
          if (i == indexSingleTileToEdit)
            singleTileBlueprints[i].copyWith(
              newType: newType,
              newEighthTurns: newEighthTurns,
              newColor: newColor,
            )
          else
            singleTileBlueprints[i],
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

@immutable
class SingleTrackTileBlueprint {
  final TrackTileType type;

  /// Specifies the exact trackTile from this [TrackTileType]
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
    } else if (type == TrackTileType.weakCurve) {
      return [
        Direction.getFromEighthTurnsFromTop(
          Direction.top.eighthTurnsFromTop + eighthTurns,
        ),
        Direction.getFromEighthTurnsFromTop(
          Direction.bottomRight.eighthTurnsFromTop + eighthTurns,
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
            singleTileBlueprints: [
              SingleTrackTileBlueprint(),
            ],
          ),
          const TrackTileStackBlueprint(
            columnIndex: 1,
            rowIndex: 0,
            singleTileBlueprints: [
              SingleTrackTileBlueprint(),
            ],
          ),
          const TrackTileStackBlueprint(
            columnIndex: 0,
            rowIndex: 1,
            singleTileBlueprints: [
              SingleTrackTileBlueprint(),
            ],
          ),
          const TrackTileStackBlueprint(
            columnIndex: 1,
            rowIndex: 1,
            singleTileBlueprints: [
              SingleTrackTileBlueprint(),
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
          blueprint.copyWithUpdatedSingleTile(
            indexSingleTileToEdit: trackTileIndex,
            newType: newType,
            newEighthTurns: newEighthTurns,
            newColor: newColor,
          )
        else
          blueprint,
    ];
    for (final blueprint in state) {
      if (blueprint.columnIndex == columnIndex &&
          blueprint.rowIndex == rowIndex) {
        _updateSideParts(blueprint);
      }
    }
  }

  void _updateSideParts(TrackTileStackBlueprint updatedBlueprint) {
    final List<TrackTileStackBlueprint> temp = List.from(state);

    for (int i = 0; i < temp.length; i++) {
      if (temp[i].columnIndex == updatedBlueprint.columnIndex &&
          temp[i].rowIndex == updatedBlueprint.rowIndex + 1) {
        Map<Direction, List<SingleTrackTileBlueprint>> sideParts =
            Map.from(temp[i].sideParts);
        sideParts[Direction.top] = updatedBlueprint.singleTileBlueprints
            .where((blueprint) =>
                blueprint.getEntrancePoints().contains(Direction.bottomLeft) ||
                blueprint.getEntrancePoints().contains(Direction.bottomRight))
            .toList();
        temp[i] = temp[i].copyWithUpdatedSideParts(
          newSideParts: sideParts,
        );
      }
    }
    for (int i = 0; i < temp.length; i++) {
      if (temp[i].columnIndex == updatedBlueprint.columnIndex - 1 &&
          temp[i].rowIndex == updatedBlueprint.rowIndex) {
        Map<Direction, List<SingleTrackTileBlueprint>> sideParts =
            Map.from(temp[i].sideParts);
        sideParts[Direction.right] = updatedBlueprint.singleTileBlueprints
            .where((blueprint) =>
                blueprint.getEntrancePoints().contains(Direction.topLeft) ||
                blueprint.getEntrancePoints().contains(Direction.bottomLeft))
            .toList();
        temp[i] = temp[i].copyWithUpdatedSideParts(
          newSideParts: sideParts,
        );
      }
    }
    for (int i = 0; i < temp.length; i++) {
      if (temp[i].columnIndex == updatedBlueprint.columnIndex &&
          temp[i].rowIndex == updatedBlueprint.rowIndex - 1) {
        Map<Direction, List<SingleTrackTileBlueprint>> sideParts =
            Map.from(temp[i].sideParts);
        sideParts[Direction.bottom] = updatedBlueprint.singleTileBlueprints
            .where((blueprint) =>
                blueprint.getEntrancePoints().contains(Direction.topLeft) ||
                blueprint.getEntrancePoints().contains(Direction.topRight))
            .toList();
        temp[i] = temp[i].copyWithUpdatedSideParts(
          newSideParts: sideParts,
        );
      }
    }
    for (int i = 0; i < temp.length; i++) {
      if (temp[i].columnIndex == updatedBlueprint.columnIndex + 1 &&
          temp[i].rowIndex == updatedBlueprint.rowIndex) {
        Map<Direction, List<SingleTrackTileBlueprint>> sideParts =
            Map.from(temp[i].sideParts);
        sideParts[Direction.left] = updatedBlueprint.singleTileBlueprints
            .where((blueprint) =>
                blueprint.getEntrancePoints().contains(Direction.topRight) ||
                blueprint.getEntrancePoints().contains(Direction.bottomRight))
            .toList();
        temp[i] = temp[i].copyWithUpdatedSideParts(
          newSideParts: sideParts,
        );
      }
    }
    state = [...temp];
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
      for (final blueprint in state
          .where((blueprint) => blueprint.rowIndex == currentRowCount - 1)) {
        _updateSideParts(blueprint);
      }
    } else {
      state = [
        for (final blueprint in state)
          blueprint.copyWithUpdatedPosition(
            newRowIndex: blueprint.rowIndex + 1,
          ),
        for (int i = 0; i < getTrackColumnCount(); i++)
          TrackTileStackBlueprint(
            columnIndex: i,
            rowIndex: 0,
          ),
      ];
      for (final blueprint
          in state.where((blueprint) => blueprint.rowIndex == 1)) {
        _updateSideParts(blueprint);
      }
    }
  }

  void removeTrackRow(Direction direction) {
    int currentRowCount = getTrackRowCount();

    if (currentRowCount > 1) {
      if (direction == Direction.bottom) {
        state = [
          for (final blueprint in state
              .where((blueprint) => blueprint.rowIndex < currentRowCount - 1))
            blueprint.copyWithUpdatedSideParts(
              newSideParts: Map.fromEntries(
                blueprint.sideParts.entries.where(
                  (mapEntry) => blueprint.rowIndex == currentRowCount - 2
                      ? mapEntry.key != Direction.bottom
                      : true,
                ),
              ),
            ),
        ];
      } else {
        state = [
          for (final blueprint
              in state.where((blueprint) => blueprint.rowIndex > 0))
            blueprint.copyWithUpdatedPosition(
              newRowIndex: blueprint.rowIndex - 1,
              newSideParts: Map.fromEntries(
                blueprint.sideParts.entries.where(
                  (mapEntry) => blueprint.rowIndex == 1
                      ? mapEntry.key != Direction.top
                      : true,
                ),
              ),
            ),
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
      for (final blueprint in state.where(
          (blueprint) => blueprint.columnIndex == currentColumnCount - 1)) {
        _updateSideParts(blueprint);
      }
    } else {
      state = [
        for (final blueprint in state)
          blueprint.copyWithUpdatedPosition(
            newColumnIndex: blueprint.columnIndex + 1,
          ),
        for (int i = 0; i < getTrackRowCount(); i++)
          TrackTileStackBlueprint(
            columnIndex: 0,
            rowIndex: i,
          )
      ];
      for (final blueprint
          in state.where((blueprint) => blueprint.columnIndex == 1)) {
        _updateSideParts(blueprint);
      }
    }
  }

  void removeTrackColumn(Direction direction) {
    int currentColumnCount = getTrackColumnCount();

    if (currentColumnCount > 1) {
      if (direction == Direction.right) {
        state = [
          for (final blueprint in state.where(
              (blueprint) => blueprint.columnIndex < currentColumnCount - 1))
            blueprint.copyWithUpdatedSideParts(
              newSideParts: Map.fromEntries(
                blueprint.sideParts.entries.where(
                  (mapEntry) => blueprint.columnIndex == currentColumnCount - 2
                      ? mapEntry.key != Direction.right
                      : true,
                ),
              ),
            ),
        ];
      } else {
        state = [
          for (final blueprint
              in state.where((blueprint) => blueprint.columnIndex > 0))
            blueprint.copyWithUpdatedPosition(
              newColumnIndex: blueprint.columnIndex - 1,
              newSideParts: Map.fromEntries(
                blueprint.sideParts.entries.where(
                  (mapEntry) => blueprint.columnIndex == 1
                      ? mapEntry.key != Direction.left
                      : true,
                ),
              ),
            ),
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
