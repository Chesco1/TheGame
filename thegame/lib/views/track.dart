import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';
import 'package:thegame/levelbuilder_popupmenus/non_closing_popupmenuitem.dart';
import 'package:thegame/levelbuilder_popupmenus/tracktile_popupmenu.dart';

class Track extends ConsumerWidget {
  static const int maxTrackTilesInRow = 15;
  static const int trackWidth = 17; // should be a number between 0 and 100
  static const double levelBuilderTileSpacing = 1;

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
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _TrackColumnController(direction: Direction.left),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _TrackRowController(direction: Direction.top),
                for (int i = 0; i < totalRows; i++) ...[
                  if (isLevelBuilder && i > 0)
                    const SizedBox(
                      height: Track.levelBuilderTileSpacing,
                    ),
                  Flexible(
                    child: _TrackRow(
                      isLevelBuilder: isLevelBuilder,
                      rowIndex: i,
                    ),
                  ),
                ],
                const _TrackRowController(direction: Direction.bottom),
              ],
            ),
          ),
          const _TrackColumnController(direction: Direction.right),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

enum TrackControllerAction { add, remove }

class _TrackRowController extends ConsumerWidget {
  final Direction direction;

  const _TrackRowController({
    Key? key,
    required this.direction,
  }) : super(key: key);

  Widget _trackRowControllerButton(
    BuildContext context,
    TrackNotifier trackNotifier,
    TrackControllerAction action,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.shortestSide / 13,
      child: AspectRatio(
        aspectRatio: 1.62,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            action == TrackControllerAction.remove
                ? trackNotifier.removeTrackRow(direction)
                : trackNotifier.addTrackRow(direction);
          },
          child: Icon(action == TrackControllerAction.remove
              ? Icons.remove
              : Icons.add),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _trackRowControllerButton(
          context,
          trackNotifier,
          TrackControllerAction.remove,
        ),
        SizedBox(width: 8),
        _trackRowControllerButton(
          context,
          trackNotifier,
          TrackControllerAction.add,
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////

class _TrackColumnController extends ConsumerWidget {
  final Direction direction;

  const _TrackColumnController({
    Key? key,
    required this.direction,
  }) : super(key: key);

  Widget _trackColumnControllerButton(
    BuildContext context,
    TrackNotifier trackNotifier,
    TrackControllerAction action,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.shortestSide / 13,
      child: AspectRatio(
        aspectRatio: 0.62,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            backgroundColor: Colors.grey,
          ),
          onPressed: () {
            action == TrackControllerAction.remove
                ? trackNotifier.removeTrackColumn(direction)
                : trackNotifier.addTrackColumn(direction);
          },
          child: Icon(action == TrackControllerAction.remove
              ? Icons.remove
              : Icons.add),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _trackColumnControllerButton(
          context,
          trackNotifier,
          TrackControllerAction.remove,
        ),
        SizedBox(height: 8),
        _trackColumnControllerButton(
          context,
          trackNotifier,
          TrackControllerAction.add,
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < totalColumns; i++) ...[
          if (isLevelBuilder && i > 0)
            const SizedBox(
              width: Track.levelBuilderTileSpacing,
            ),
          Flexible(
            child: _PositionedTrackTileStack(
              columnIndex: i,
              rowIndex: rowIndex,
              isLevelBuilder: isLevelBuilder,
            ),
          ),
        ],
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

    final trackTileStackBlueprint = ref.watch(trackBlueprintProvider.select(
      (blueprints) {
        int index = trackNotifier.getTrackTileIndex(
          columnIndex,
          rowIndex,
        );
        return !index.isNegative ? blueprints[index] : null;
      },
    ));

    if (trackTileStackBlueprint != null) {
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
          singleTrackTileBlueprints:
              trackTileStackBlueprint.singleTileBlueprints,
          isLevelBuilder: isLevelBuilder,
          sideTrackTiles: trackTileStackBlueprint.sideParts,
        ),
      );
    } else {
      return Container();
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class TrackTileStack extends ConsumerWidget {
  final List<SingleTrackTileBlueprint> singleTrackTileBlueprints;
  final bool isLevelBuilder;
  final double? size;
  final Map<Direction, List<SingleTrackTileBlueprint>> sideTrackTiles;
  const TrackTileStack({
    Key? key,
    this.singleTrackTileBlueprints = const [],
    this.isLevelBuilder = false,
    this.size,
    this.sideTrackTiles = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: size,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: isLevelBuilder ? Colors.black12 : null,
          child: Stack(
            children: [
              for (final direction in sideTrackTiles.keys)
                for (final blueprint in sideTrackTiles[direction]!.where(
                  (blueprint) =>
                      blueprint
                          .getEntrancePoints()
                          .contains(Direction.topRight) ||
                      blueprint
                          .getEntrancePoints()
                          .contains(Direction.bottomLeft),
                ))
                  SingleTrackTile(
                    sideTileToPaint: direction,
                    strongCurvePartToPaint: StrongCurvePart.under,
                    type: blueprint.type,
                    eighthTurns: blueprint.eighthTurns,
                    color: blueprint.color,
                    size: size,
                    isLevelBuilder: isLevelBuilder,
                  ),
              for (final blueprint in singleTrackTileBlueprints)
                SingleTrackTile(
                  type: blueprint.type,
                  eighthTurns: blueprint.eighthTurns,
                  color: blueprint.color,
                  size: size,
                  isLevelBuilder: isLevelBuilder,
                ),
              for (final direction in sideTrackTiles.keys)
                for (final blueprint in sideTrackTiles[direction]!.where(
                  (blueprint) =>
                      blueprint
                          .getEntrancePoints()
                          .contains(Direction.topLeft) ||
                      blueprint
                          .getEntrancePoints()
                          .contains(Direction.bottomRight),
                ))
                  SingleTrackTile(
                    sideTileToPaint: direction,
                    strongCurvePartToPaint: StrongCurvePart.over,
                    type: blueprint.type,
                    eighthTurns: blueprint.eighthTurns,
                    color: blueprint.color,
                    size: size,
                    isLevelBuilder: isLevelBuilder,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class SingleTrackTile extends ConsumerWidget {
  final TrackTileType type;
  final int eighthTurns;
  final TrackColor color;
  final double? size;
  final bool isLevelBuilder;
  final Direction? sideTileToPaint;
  final StrongCurvePart strongCurvePartToPaint;

  const SingleTrackTile({
    Key? key,
    required this.type,
    required this.eighthTurns,
    this.color = TrackColor.none,
    this.size,
    this.isLevelBuilder = false,
    this.sideTileToPaint,
    this.strongCurvePartToPaint = StrongCurvePart.both,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: size,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRect(
          child: CustomPaint(
            size: Size.infinite,
            painter: LinePainter(
              type: type,
              eighthTurns: eighthTurns,
              color: color,
              sideTileToPaint: sideTileToPaint,
              strongCurvePartToPaint: strongCurvePartToPaint,
              isLevelBuilder: isLevelBuilder,
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

enum StrongCurvePart { over, under, both }

class LinePainter extends CustomPainter {
  final TrackTileType type;
  final int eighthTurns;
  final TrackColor color;

  final Direction? sideTileToPaint;
  final StrongCurvePart strongCurvePartToPaint;
  final bool isLevelBuilder;

  const LinePainter({
    required this.type,
    required this.eighthTurns,
    required this.color,
    this.sideTileToPaint,
    this.strongCurvePartToPaint = StrongCurvePart.both,
    this.isLevelBuilder = false,
  });

  Color _getPaintColor() {
    double opacity = 0.77;

    if (color == TrackColor.red) {
      return Colors.red.withOpacity(opacity);
    } else if (color == TrackColor.green) {
      return Colors.green.withOpacity(opacity);
    } else if (color == TrackColor.blue) {
      return Colors.blue.withOpacity(opacity);
    }
    return Colors.black.withOpacity(opacity);
  }

  Paint _makePaint(Size canvasSize) {
    return (Paint()
      ..color = _getPaintColor()
      ..strokeWidth = (Track.trackWidth / 100.0) * canvasSize.height
      ..style = PaintingStyle.stroke
      ..strokeCap =
          sideTileToPaint == null ? StrokeCap.square : StrokeCap.butt);
  }

  void _paintQuarterTurn(Canvas canvas, Size canvasSize, Paint paint) {
    if (eighthTurns.isEven) {
      _paintQuarterTurnFromTop(canvas, canvasSize, paint);
    } else {
      _paintQuarterTurnFromTopRight(canvas, canvasSize, paint);
    }
  }

  void _paintStraightLine(Canvas canvas, Size canvasSize, Paint paint) {
    if (eighthTurns.isEven) {
      _paintStraightLineFromTop(canvas, canvasSize, paint);
    } else {
      _paintStraightLineFromTopRight(canvas, canvasSize, paint);
    }
  }

  void _paintEighthTurn(Canvas canvas, Size canvasSize, Paint paint) {
    if (eighthTurns.isEven) {
      _paintEighthTurnFromTop(canvas, canvasSize, paint);
    } else {
      _paintEighthTurnFromTopRight(canvas, canvasSize, paint);
    }
  }

  void translateCanvas(Canvas canvas, Size size) {
    if (sideTileToPaint == Direction.top) {
      canvas.translate(
        0,
        -(size.height + (isLevelBuilder ? Track.levelBuilderTileSpacing : 0)),
      );
    } else if (sideTileToPaint == Direction.right) {
      canvas.translate(
        (size.width + (isLevelBuilder ? Track.levelBuilderTileSpacing : 0)),
        0,
      );
    } else if (sideTileToPaint == Direction.bottom) {
      canvas.translate(
        0,
        (size.height + (isLevelBuilder ? Track.levelBuilderTileSpacing : 0)),
      );
    } else if (sideTileToPaint == Direction.left) {
      canvas.translate(
        -(size.width + (isLevelBuilder ? Track.levelBuilderTileSpacing : 0)),
        0,
      );
    }
  }

  void rotateCanvas(Canvas canvas, Size canvasSize, int eighthTurns) {
    canvas.translate(canvasSize.width / 2, canvasSize.height / 2);
    canvas.rotate((pi / 4) * (eighthTurns % 8));
    canvas.translate(-(canvasSize.width / 2), -(canvasSize.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = _makePaint(size);

    translateCanvas(canvas, size);
    rotateCanvas(
      canvas,
      size,
      eighthTurns.isEven ? eighthTurns : eighthTurns - 1,
    );

    if (type == TrackTileType.straight) {
      _paintStraightLine(canvas, size, paint);
    } else if (type == TrackTileType.strongCurve) {
      _paintQuarterTurn(canvas, size, paint);
    } else if (type == TrackTileType.weakCurve) {
      _paintEighthTurn(canvas, size, paint);
    }
  }

/////////////////////////// Straight Lines /////////////////////////////////////

  void _paintStraightLineFromTop(Canvas canvas, Size canvasSize, Paint paint) {
    canvas.drawLine(
      Offset(canvasSize.width * 0.5, 0),
      Offset(canvasSize.width * 0.5, canvasSize.height),
      paint,
    );
  }

  void _paintStraightLineFromTopRight(
      Canvas canvas, Size canvasSize, Paint paint) {
    canvas.drawLine(
      Offset(canvasSize.width, 0.0),
      Offset(0.0, canvasSize.height),
      paint,
    );
  }

//////////////////////////// Quarter Turns /////////////////////////////////////

  void _paintQuarterTurnFromTop(Canvas canvas, Size canvasSize, Paint paint) {
    Rect rect = Rect.fromCenter(
      center: Offset(canvasSize.width, 0.0),
      height: canvasSize.height,
      width: canvasSize.width,
    );
    canvas.drawArc(rect, pi * 0.5, pi * 0.5, false, paint);
  }

  void _paintQuarterTurnFromTopRight(
      Canvas canvas, Size canvasSize, Paint paint) {
    Rect rect = Rect.fromCenter(
      center: Offset(
        canvasSize.width * 1.5,
        canvasSize.height * 0.5,
      ),
      height: sqrt(pow(canvasSize.width, 2) + pow(canvasSize.height, 2)),
      width: sqrt(pow(canvasSize.width, 2) + pow(canvasSize.height, 2)),
    );
    canvas.drawArc(
      rect,
      _getQuarterTurnFromTopRightStartAngle(),
      (strongCurvePartToPaint == StrongCurvePart.both ? pi * 0.5 : pi * 0.25),
      false,
      paint,
    );
  }

  double _getQuarterTurnFromTopRightStartAngle() {
    if (strongCurvePartToPaint == StrongCurvePart.over) {
      if (eighthTurns == 1 || eighthTurns == 5) {
        return pi * 0.75;
      }
      return pi;
    } else if (strongCurvePartToPaint == StrongCurvePart.under) {
      if (eighthTurns == 1 || eighthTurns == 5) {
        return pi;
      }
      return pi * 0.75;
    }
    return pi * 0.75;
  }

/////////////////////////// Eighth Turns ///////////////////////////////////////

  void _paintEighthTurnFromTop(
    Canvas canvas,
    Size canvasSize,
    Paint paint,
  ) {
    double oldRadius = sqrt(pow(canvasSize.height, 2) * 2);

    double resizeFactor = canvasSize.height /
        ((canvasSize.height - (oldRadius - canvasSize.height)) * 2);

    double newRadius = oldRadius * resizeFactor;

    Rect rect = Rect.fromCenter(
      center: Offset(
        (canvasSize.width * 2) -
            ((oldRadius - newRadius) +
                ((canvasSize.height / 2) - (oldRadius - canvasSize.height))),
        0.0,
      ),
      height: newRadius * 2,
      width: newRadius * 2,
    );

    canvas.drawArc(rect, pi * 0.75, pi * 0.25, false, paint);

    canvas.drawLine(
      Offset(
        canvasSize.height,
        canvasSize.height,
      ),
      Offset(
        (canvasSize.height * resizeFactor) +
            (sideTileToPaint == null ? (paint.strokeWidth * 0.35) : 0),
        (canvasSize.height * resizeFactor) +
            (sideTileToPaint == null ? (paint.strokeWidth * 0.35) : 0),
      ),
      paint..strokeCap = StrokeCap.butt,
    );
  }

  void _paintEighthTurnFromTopRight(
      Canvas canvas, Size canvasSize, Paint paint) {
    canvas.scale(1, -1);
    canvas.translate(0, -(canvasSize.height));
    _paintEighthTurnFromTop(canvas, canvasSize, paint);
  }

////////////////////////////////////////////////////////////////////////////////

  @override
  bool shouldRepaint(LinePainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.eighthTurns != eighthTurns ||
      oldDelegate.color != color;
}
