import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';

class TrackBlock extends ConsumerWidget {
  final int index;

  const TrackBlock({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? color =
        ref.watch(trackBlueprintProvider.select((value) => value[index].color));

    return AspectRatio(
      aspectRatio: 1,
      child: Container(color: color),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class SingleTrackPart extends ConsumerWidget {
  final int index;
  const SingleTrackPart({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
