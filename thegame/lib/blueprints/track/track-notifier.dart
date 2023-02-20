import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track/tracktile_blueprints.dart';

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
            .where((blueprint) => [Direction.bottomLeft, Direction.bottomRight]
                .any(blueprint.getEntrancePoints().contains))
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
            .where((blueprint) => [Direction.topLeft, Direction.bottomLeft]
                .any(blueprint.getEntrancePoints().contains))
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
            .where((blueprint) => [Direction.topLeft, Direction.topRight]
                .any(blueprint.getEntrancePoints().contains))
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
            .where((blueprint) => [Direction.topRight, Direction.bottomRight]
                .any(blueprint.getEntrancePoints().contains))
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

  void addTrackTile(int columnIndex, int rowIndex) {
    state = [
      for (final blueprint in state)
        if (blueprint.columnIndex == columnIndex &&
            blueprint.rowIndex == rowIndex)
          blueprint.copyWithAddedSingleTile()
        else
          blueprint,
    ];
  }

  void removeTrackTile(int columnIndex, int rowIndex, indexTrackTileToRemove) {
    state = [
      for (final blueprint in state)
        if (blueprint.columnIndex == columnIndex &&
            blueprint.rowIndex == rowIndex)
          blueprint.copyWithRemovedSingleTile(indexTrackTileToRemove)
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
}

////////////////////////////////////////////////////////////////////////////////

final trackBlueprintProvider =
    StateNotifierProvider<TrackNotifier, List<TrackTileStackBlueprint>>((ref) {
  return TrackNotifier();
});
