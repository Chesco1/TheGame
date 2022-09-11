import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';
import 'package:thegame/levelbuilder_popupmenus/non_closing_popupmenuitem.dart';
import 'package:thegame/levelbuilder_popupmenus/tracktile_popupmenu.dart';
import 'package:thegame/train/train_info.dart';

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

    ref.watch(trackBlueprintProvider.select((value) => value.length));
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TrackRowController(direction: Direction.up),
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

////////////////////////////////////////////////////////////////////////////////

class _TrackRowController extends ConsumerWidget {
  final Direction direction;

  const _TrackRowController({
    Key? key,
    required this.direction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.shortestSide / 12,
          child: AspectRatio(
            aspectRatio: 1.62,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                backgroundColor: Colors.grey,
              ),
              onPressed: () {
                trackNotifier.removeTrackRow(Direction.up);
              },
              child: Icon(Icons.remove),
            ),
          ),
        ),
        SizedBox(width: 5),
        SizedBox(
          height: MediaQuery.of(context).size.shortestSide / 12,
          child: AspectRatio(
            aspectRatio: 1.62,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                backgroundColor: Colors.grey,
              ),
              onPressed: () {
                trackNotifier.addTrackRow(Direction.up);
              },
              child: Icon(Icons.add),
            ),
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
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);
    int totalColumns = trackNotifier.getTrackColumnCount();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < totalColumns; i++)
          Flexible(
            child: _PositionedTrackTileStack(
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
/// position is specified with the [columnIndex] and [rowIndex] parameters.
/// The widget will use these to find the correct [TrackTileStackBlueprint]
/// from the [TrackNotifier] and build accordingly.
/// Not adhering to this may trigger a providerNotFoundException.
class _PositionedTrackTileStack extends ConsumerWidget {
  final int columnIndex;
  final int rowIndex;
  final bool isLevelBuilder;

  const _PositionedTrackTileStack({
    Key? key,
    required this.columnIndex,
    required this.rowIndex,
    this.isLevelBuilder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

    final trackTileStackBlueprint = ref.watch(
      trackBlueprintProvider.select(
        (blueprints) => blueprints[trackNotifier.getTrackTileIndex(
          columnIndex,
          rowIndex,
        )],
      ),
    );

    return PopupMenuButton(
      enabled: isLevelBuilder,
      itemBuilder: (context) => [
        NonClosingPopupMenuItem(
          child: Center(
            child: TrackTilePopupMenu(
              columnIndex: columnIndex,
              rowIndex: rowIndex,
            ),
          ),
        ),
      ],
      child: TrackTileStack(
        singleTrackTileBlueprints: trackTileStackBlueprint.singlePartBlueprints,
        isLevelBuilder: isLevelBuilder,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class TrackTileStack extends ConsumerWidget {
  final List<SingleTrackTileBlueprint> singleTrackTileBlueprints;
  final bool isLevelBuilder;
  final double? size;
  const TrackTileStack({
    Key? key,
    this.singleTrackTileBlueprints = const [],
    this.isLevelBuilder = false,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: size,
      child: ClipRRect(
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: isLevelBuilder ? const EdgeInsets.all(0.5) : null,
            color: isLevelBuilder ? Colors.black12 : null,
            child: Stack(
              children: [
                for (int i = 0; i < singleTrackTileBlueprints.length; i++)
                  SingleTrackTile(
                    trackTileIndex: i,
                    type: singleTrackTileBlueprints[i].type,
                    typeIndex: singleTrackTileBlueprints[i].typeIndex,
                    color: singleTrackTileBlueprints[i].color,
                    size: size,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class SingleTrackTile extends ConsumerWidget {
  final int trackTileIndex;
  final TrackTileType type;
  final int typeIndex;
  final TrackColor color;
  final double? size;

  const SingleTrackTile({
    Key? key,
    required this.trackTileIndex,
    required this.type,
    required this.typeIndex,
    this.color = TrackColor.none,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: size,
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          size: Size.infinite,
          painter: LinePainter(type, typeIndex, color),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class LinePainter extends CustomPainter {
  final TrackTileType type;
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
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.clipRect(rect);
    if (type == TrackTileType.straight) {
      _paintStraightLine(canvas, size, paint);
    } else if (type == TrackTileType.strongCurve) {
      _paintStrongCurve(canvas, size, paint);
    }
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

  @override
  bool shouldRepaint(LinePainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.typeIndex != typeIndex ||
      oldDelegate.color != color;
}
