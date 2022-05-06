import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';

class TrackBlock extends ConsumerWidget {
  static const int tapeWidth = 10; // should be a number between 0 and 100
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
      ..strokeWidth = (TrackBlock.tapeWidth / 100.0) * canvasSize.height
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
      _paintStraightLine(canvas, size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
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
