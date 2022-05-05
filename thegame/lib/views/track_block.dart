import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';

class TrackBlock extends ConsumerWidget {
  final int trackBlockIndex;
  final int columnIndex;
  final int rowIndex;
  final List<SingleTrackPartBlueprint> singlePartBlueprints;

  const TrackBlock({
    Key? key,
    required this.trackBlockIndex,
    required this.columnIndex,
    required this.rowIndex,
    required this.singlePartBlueprints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class SingleTrackPart extends ConsumerWidget {
  final int trackPartIndex;
  final TrackPartType type;
  final int typeIndex;
  final TrackColor color;

  const SingleTrackPart({
    Key? key,
    required this.trackPartIndex,
    required this.type,
    required this.typeIndex,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(),
    );
  }
}
