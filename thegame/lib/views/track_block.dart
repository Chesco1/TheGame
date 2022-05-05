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
  // int trackBlockIndex
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
      child: ClipRRect(
        child: Container(
          alignment: Alignment.center,
          child: CustomPaint(
            size: Size.infinite,
            painter: LinePainter(type, typeIndex, color),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class LinePainter extends CustomPainter {
  const LinePainter(
    TrackPartType type,
    int typeIndex,
    TrackColor color,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
