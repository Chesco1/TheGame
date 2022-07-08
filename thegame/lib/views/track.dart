import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';
import 'package:thegame/views/track_block.dart';

class Track extends ConsumerWidget {
  const Track({Key? key}) : super(key: key);

  int getTrackRowCount(List<TrackBlockBlueprint> trackBlueprint) {
    int highest = 0;

    for (TrackBlockBlueprint blueprint in trackBlueprint) {
      if (blueprint.rowIndex >= highest) {
        highest = blueprint.rowIndex + 1;
      }
    }
    return highest;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackBlueprint = ref.read(trackBlueprintProvider);
    return Column(
      children: [
        for (TrackBlockBlueprint blueprint in trackBlueprint)
          Container(
            alignment: Alignment.center,
            height: 10,
            color: Colors.blue,
          ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////

class TrackRow extends ConsumerWidget {
  const TrackRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
