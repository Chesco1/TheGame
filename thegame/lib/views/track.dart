import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';

class Track extends ConsumerWidget {
  static const int maxTrackTilesInRow = 12;
  static const int trackWidth = 10; // should be a number between 0 and 100

  final bool isLevelBuilder;

  const Track({
    Key? key,
    required this.isLevelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackBlueprint = ref.watch(trackBlueprintProvider.notifier);
    int totalRows = trackBlueprint.getTrackRowCount();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < totalRows; i++)
          Flexible(
            child: _TrackRow(
              isLevelBuilder: isLevelBuilder,
              rowIndex: i,
            ),
          ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////

/// This Widget is only to be used as a child of the Track widget
class _TrackRow extends ConsumerWidget {
  final bool isLevelBuilder;
  final int rowIndex;

  const _TrackRow({
    Key? key,
    required this.isLevelBuilder,
    required this.rowIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackBlueprint = ref.watch(trackBlueprintProvider.notifier);
    int totalColumns = trackBlueprint.getTrackColumnCount();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < totalColumns; i++)
          Flexible(
            child: _PositionedTrackTile(
              columnIndex: i,
              rowIndex: rowIndex,
              isLevelBuilder: isLevelBuilder,
            ),
          )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

/// This widget is only to be used as child of the TrackRow widget where the
/// track has to be specified with the [columnIndex] and [rowIndex] parameters
class _PositionedTrackTile extends ConsumerWidget {
  final bool isLevelBuilder;
  final int columnIndex;
  final int rowIndex;

  const _PositionedTrackTile({
    Key? key,
    required this.columnIndex,
    required this.rowIndex,
    required this.isLevelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int trackTileIndex = ref
        .watch(trackBlueprintProvider.notifier)
        .getTrackTileIndex(columnIndex, rowIndex);

    final trackTileBlueprint = ref.watch(
      trackBlueprintProvider.select(
        (blueprints) => blueprints[trackTileIndex],
      ),
    );

    final singlePartBlueprints = trackTileBlueprint.singlePartBlueprints;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.black12,
        child: Stack(
          children: [
            for (int i = 0; i < singlePartBlueprints.length; i++)
              SingleTrackPart(
                trackPartIndex: i,
                type: singlePartBlueprints[i].type,
                typeIndex: singlePartBlueprints[i].typeIndex,
                color: singlePartBlueprints[i].color,
              )
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class TrackTileBackGround extends ConsumerWidget {
  final bool isLevelBuilder;
  final Widget? child;
  const TrackTileBackGround({
    Key? key,
    required this.isLevelBuilder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      child: Container(
        color: isLevelBuilder == true ? Colors.black26 : null,
        child: child,
      ),
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
    this.color = TrackColor.none,
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
  final TrackPartType type;
  final int typeIndex;
  final TrackColor color;

  const LinePainter(
    this.type,
    this.typeIndex,
    this.color,
  );

  Color _getPaintColor() {
    if (color == TrackColor.red) {
      return Colors.red;
    } else if (color == TrackColor.green) {
      return Colors.green;
    } else if (color == TrackColor.blue) {
      return Colors.blue;
    }
    return Colors.black;
  }

  Paint _makePaint(Size canvasSize) {
    return (Paint()
      ..color = _getPaintColor()
      ..strokeWidth = (Track.trackWidth / 100.0) * canvasSize.height
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square);
  }

  void _paintStrongCurve(Canvas canvas, Size canvasSize, Paint paint) {
    if (typeIndex == 0) {
      _paintStrongCurve0(canvas, canvasSize, paint);
    } else if (typeIndex == 1) {
      _paintStrongCurve1(canvas, canvasSize, paint);
    } else if (typeIndex == 2) {
      _paintStrongCurve2(canvas, canvasSize, paint);
    } else if (typeIndex == 3) {
      _paintStrongCurve3(canvas, canvasSize, paint);
    }
  }

  void _paintStraightLine(Canvas canvas, Size canvasSize, Paint paint) {
    if (typeIndex == 0) {
      _paintStraight0(canvas, canvasSize, paint);
    } else if (typeIndex == 1) {
      _paintStraight1(canvas, canvasSize, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = _makePaint(size);

    if (type == TrackPartType.straight) {
      _paintStraightLine(canvas, size, paint);
    } else if (type == TrackPartType.strongCurve) {
      _paintStrongCurve(canvas, size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  ///////////////////// Straight Lines /////////////////////////////////////////

  void _paintStraight0(Canvas canvas, Size canvasSize, Paint paint) {
    canvas.drawLine(
      Offset(0.0, canvasSize.height * 0.5),
      Offset(canvasSize.width, canvasSize.height * 0.5),
      paint,
    );
  }

  void _paintStraight1(Canvas canvas, Size canvasSize, Paint paint) {
    canvas.drawLine(
      Offset(canvasSize.width * 0.5, 0.0),
      Offset(canvasSize.width * 0.5, canvasSize.height),
      paint,
    );
  }

  ///////////////////// Strong Curves Lines ////////////////////////////////////

  void _paintStrongCurve0(Canvas canvas, Size canvasSize, Paint paint) {
    Rect rect = Rect.fromCenter(
      center: Offset(canvasSize.width, 0.0),
      height: canvasSize.height,
      width: canvasSize.width,
    );
    canvas.drawArc(rect, pi * 0.5, pi * 0.5, false, paint);
  }

  void _paintStrongCurve1(Canvas canvas, Size canvasSize, Paint paint) {
    Rect rect = Rect.fromCenter(
      center: Offset(canvasSize.width, canvasSize.height),
      height: canvasSize.height,
      width: canvasSize.width,
    );
    canvas.drawArc(rect, pi, pi * 0.5, false, paint);
  }

  void _paintStrongCurve2(Canvas canvas, Size canvasSize, Paint paint) {
    Rect rect = Rect.fromCenter(
      center: Offset(0, canvasSize.height),
      height: canvasSize.height,
      width: canvasSize.width,
    );
    canvas.drawArc(rect, pi * 1.5, pi * 0.5, false, paint);
  }

  void _paintStrongCurve3(Canvas canvas, Size canvasSize, Paint paint) {
    Rect rect = Rect.fromCenter(
      center: Offset(0.0, 0.0),
      height: canvasSize.height,
      width: canvasSize.width,
    );
    canvas.drawArc(rect, 0.0, pi * 0.5, false, paint);
  }
}
