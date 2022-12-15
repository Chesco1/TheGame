import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';
import 'package:thegame/views/track.dart';

class TrackTilePopupMenu extends ConsumerStatefulWidget {
  final int columnIndex;
  final int rowIndex;

  const TrackTilePopupMenu({
    Key? key,
    required this.columnIndex,
    required this.rowIndex,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrackTilePopupMenuState();
}

class _TrackTilePopupMenuState extends ConsumerState<TrackTilePopupMenu> {
  late final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

  Widget _tileRemoveButton(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          trackNotifier.addTrackTile(widget.columnIndex, widget.rowIndex);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _tileAddButton(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          trackNotifier.addTrackTile(widget.columnIndex, widget.rowIndex);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trackTileStackBlueprint = ref.watch(
      trackBlueprintProvider.select(
        (blueprints) => blueprints[trackNotifier.getTrackTileIndex(
          widget.columnIndex,
          widget.rowIndex,
        )],
      ),
    );

    int selectedSingleTileIndex =
        trackTileStackBlueprint.singleTileBlueprints.length - 1;

    return SizedBox(
      width: MediaQuery.of(context).size.shortestSide * 0.9,
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final singleTileBlueprint
                            in trackTileStackBlueprint
                                .singleTileBlueprints) ...[
                          TrackTileStack(
                            isLevelBuilder: true,
                            size: constraints.maxWidth * 0.2,
                            singleTrackTileBlueprints: [
                              SingleTrackTileBlueprint(
                                type: singleTileBlueprint.type,
                                eighthTurns: singleTileBlueprint.eighthTurns,
                                color: singleTileBlueprint.color,
                              ),
                            ],
                          ),
                          SizedBox(width: 4),
                        ],
                        _tileAddButton(constraints.maxWidth * 0.2),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 4),
                _tileRemoveButton(constraints.maxWidth * 0.2),
              ],
            ),
            SizedBox(height: 8),
            _ColorPickRow(
              columnIndex: widget.columnIndex,
              rowIndex: widget.rowIndex,
              trackTileIndex: selectedSingleTileIndex,
              currentColor:
                  trackTileStackBlueprint.singleTileBlueprints.first.color,
            ),
            SizedBox(height: 8),
            _TrackTileSelector(
              columnIndex: widget.columnIndex,
              rowIndex: widget.rowIndex,
              trackTileIndex: selectedSingleTileIndex,
              currentType:
                  trackTileStackBlueprint.singleTileBlueprints.first.type,
              currentEighthTurns: trackTileStackBlueprint
                  .singleTileBlueprints.first.eighthTurns,
              color: trackTileStackBlueprint.singleTileBlueprints.first.color,
            ),
          ],
        );
      }),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class _ColorPickRow extends ConsumerWidget {
  final int columnIndex;
  final int rowIndex;
  final int trackTileIndex;
  final TrackColor currentColor;

  const _ColorPickRow({
    Key? key,
    required this.columnIndex,
    required this.rowIndex,
    required this.trackTileIndex,
    required this.currentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

    return Row(
      children: [
        for (final trackColor in TrackColor.values) ...[
          Flexible(
            child: AspectRatio(
              aspectRatio: 1.5,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: (() {
                  trackNotifier.updateTrackTileStack(
                    columnIndex: columnIndex,
                    rowIndex: rowIndex,
                    trackTileIndex: trackTileIndex,
                    newColor: trackColor,
                  );
                }),
                child: Container(
                  decoration: BoxDecoration(
                    border: trackColor == currentColor
                        ? Border.all(
                            color: Colors.amber,
                            width: 2,
                          )
                        : null,
                    color: trackColor.paintColor,
                  ),
                ),
              ),
            ),
          ),
          if (trackColor != TrackColor.values.last) SizedBox(width: 4),
        ],
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class _TrackTileSelector extends ConsumerStatefulWidget {
  final int columnIndex;
  final int rowIndex;
  final int trackTileIndex;
  final TrackTileType currentType;
  final int currentEighthTurns;
  final TrackColor color;

  const _TrackTileSelector({
    Key? key,
    required this.columnIndex,
    required this.rowIndex,
    required this.trackTileIndex,
    required this.currentType,
    required this.currentEighthTurns,
    required this.color,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrackTileSelectorState();
}

class _TrackTileSelectorState extends ConsumerState<_TrackTileSelector> {
  late TrackTileType selectedType = widget.currentType == TrackTileType.none
      ? TrackTileType.straight
      : widget.currentType;

  @override
  Widget build(BuildContext context) {
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

    final trackTileStackBlueprint = ref.watch(
      trackBlueprintProvider.select(
        (blueprints) => blueprints[trackNotifier.getTrackTileIndex(
          widget.columnIndex,
          widget.rowIndex,
        )],
      ),
    );

    return Container(
      color: Colors.blueGrey[50],
      child: Column(
        children: [
          Row(
            children: [
              for (final type in TrackTileType.values
                  .where((type) => type != TrackTileType.none)) ...[
                Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                    onPressed: (() {
                      setState(() {
                        selectedType = type;
                      });
                    }),
                    child: Container(
                      color: type != selectedType ? Colors.black38 : null,
                      child: SingleTrackTile(
                        type: type,
                        eighthTurns: 0,
                        color: trackTileStackBlueprint
                                    .singleTileBlueprints.length >
                                widget.trackTileIndex
                            ? trackTileStackBlueprint
                                .singleTileBlueprints[widget.trackTileIndex]
                                .color
                            : TrackColor.none,
                      ),
                    ),
                  ),
                ),
                if (type != TrackTileType.values.last) SizedBox(width: 4),
              ],
            ],
          ),
          SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              const int tilesPerRow = 4;
              const double spaceBetweenTiles = 5;
              return Wrap(
                spacing: spaceBetweenTiles,
                runSpacing: spaceBetweenTiles,
                children: [
                  for (int i = 0; i < selectedType.tileAmount; i++)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      onPressed: (() {
                        trackNotifier.updateTrackTileStack(
                          columnIndex: widget.columnIndex,
                          rowIndex: widget.rowIndex,
                          trackTileIndex: widget.trackTileIndex,
                          newType: selectedType,
                          newEighthTurns: i,
                        );
                      }),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: selectedType == widget.currentType &&
                                  widget.currentEighthTurns == i
                              ? Border.all(
                                  color: Colors.amber,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: TrackTileStack(
                          isLevelBuilder: true,
                          size: (constraints.maxWidth -
                                  (tilesPerRow - 1) * spaceBetweenTiles) /
                              tilesPerRow,
                          singleTrackTileBlueprints: [
                            SingleTrackTileBlueprint(
                              type: selectedType,
                              eighthTurns: i,
                              color: widget.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
