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
      sideParts: sideParts,
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
      sideParts: sideParts,
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
      sideParts: sideParts,
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
