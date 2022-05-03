import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/views/track_block.dart';

class Track extends ConsumerWidget {
  const Track({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      crossAxisCount: 2,
      children: [
        TrackBlock(),
        TrackBlock(),
        TrackBlock(),
        TrackBlock(),
      ],
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
