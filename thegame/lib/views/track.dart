import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';
import 'package:thegame/views/track_block.dart';

class Track extends ConsumerWidget {
  const Track({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Flexible(
          child: Row(
            children: [
              Flexible(child: TrackBlock(index: 0)),
              Flexible(child: TrackBlock(index: 1)),
            ],
          ),
        ),
        Flexible(
          child: Row(
            children: [
              Flexible(child: TrackBlock(index: 2)),
              Flexible(child: TrackBlock(index: 3)),
            ],
          ),
        )
      ],
    );
  }
}
