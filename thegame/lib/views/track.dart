import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';
import 'package:thegame/views/track_block.dart';

class Track extends ConsumerWidget {
  const Track({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

final trackBlueprint = ref.read(trackBlueprintProvider);
    return Column(
      children: [
        for (TrackBlockBlueprint blueprint in trackBlueprint.where((element) => element.columnIndex == 3.))
        
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
