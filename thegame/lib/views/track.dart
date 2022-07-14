import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';
import 'package:thegame/views/track_tile.dart';

class Track extends ConsumerWidget {
  const Track({Key? key}) : super(key: key);

  static int getTrackRowCount(List<TrackTileBlueprint> trackBlueprint) {
    int highest = 0;

    for (TrackTileBlueprint blueprint in trackBlueprint) {
      if (blueprint.rowIndex >= highest) {
        highest = blueprint.rowIndex + 1;
      }
    }
    return highest;
  }

  static int getTrackColumnCount(List<TrackTileBlueprint> trackBlueprint) {
    int highest = 0;

    for (TrackTileBlueprint blueprint in trackBlueprint) {
      if (blueprint.columnIndex >= highest) {
        highest = blueprint.columnIndex + 1;
      }
    }
    return highest;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackBlueprint = ref.read(trackBlueprintProvider);
    int totalRows = getTrackRowCount(trackBlueprint);

    return Column(
      children: [
        for (int i = 0; i < totalRows; i++) TrackRow(rowIndex: i),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////

class TrackRow extends ConsumerWidget {
  final int rowIndex;

  const TrackRow({Key? key, required this.rowIndex}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackBlueprint = ref.read(trackBlueprintProvider);
    int totalColumns = Track.getTrackColumnCount(trackBlueprint);

    return Row(
      children: [
        for (int i = 0; i < totalColumns; i++)
          TrackTile(
            columnIndex: i,
            rowIndex: rowIndex,
          )
      ],
    );
  }
}
