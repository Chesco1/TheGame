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
  late TrackTileStackBlueprint trackTileStackBlueprint;
  late int indexSelectedSingleTile =
      trackTileStackBlueprint.singleTileBlueprints.length - 1;
  late final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

  Widget _tileRemoveButton(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          if (trackTileStackBlueprint.singleTileBlueprints.length == 1) {
            trackNotifier.updateTrackTileStack(
              columnIndex: widget.columnIndex,
              rowIndex: widget.rowIndex,
              trackTileIndex: indexSelectedSingleTile,
              newType: TrackTileType.none,
              newEighthTurns: 0,
              newColor: TrackColor.none,
            );
          } else {
            if (indexSelectedSingleTile ==
                trackTileStackBlueprint.singleTileBlueprints.length - 1) {
              indexSelectedSingleTile--;
            }
            trackNotifier.removeTrackTile(
              widget.columnIndex,
              widget.rowIndex,
              indexSelectedSingleTile,
            );
          }
        },
        child: Icon(
          Icons.delete,
          size: size,
          color: Colors.deepOrange,
        ),
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
          indexSelectedSingleTile =
              trackTileStackBlueprint.singleTileBlueprints.length;
          trackNotifier.addTrackTile(widget.columnIndex, widget.rowIndex);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    trackTileStackBlueprint = ref.watch(
      trackBlueprintProvider.select(
        (blueprints) => blueprints[trackNotifier.getTrackTileIndex(
          widget.columnIndex,
          widget.rowIndex,
        )],
      ),
    );

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
                        for (int i = 0;
                            i <
                                trackTileStackBlueprint
                                    .singleTileBlueprints.length;
                            i++) ...[
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                            ),
                            onPressed: (() {
                              setState(() {
                                indexSelectedSingleTile = i;
                              });
                            }),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: indexSelectedSingleTile == i
                                    ? Border.all(
                                        color: Colors.amber,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: TrackTileStack(
                                isLevelBuilder: true,
                                size: constraints.maxWidth * 0.2,
                                singleTrackTileBlueprints: [
                                  SingleTrackTileBlueprint(
                                    type: trackTileStackBlueprint
                                        .singleTileBlueprints[i].type,
                                    eighthTurns: trackTileStackBlueprint
                                        .singleTileBlueprints[i].eighthTurns,
                                    color: trackTileStackBlueprint
                                        .singleTileBlueprints[i].color,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                        ],
                        if (trackTileStackBlueprint
                                .singleTileBlueprints.last.type !=
                            TrackTileType.none)
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
              trackTileIndex: indexSelectedSingleTile,
              currentColor: trackTileStackBlueprint
                  .singleTileBlueprints[indexSelectedSingleTile].color,
            ),
            SizedBox(height: 8),
            _TrackTileSelector(
              key: UniqueKey(),
              columnIndex: widget.columnIndex,
              rowIndex: widget.rowIndex,
              trackTileIndex: indexSelectedSingleTile,
              currentType: trackTileStackBlueprint
                  .singleTileBlueprints[indexSelectedSingleTile].type,
              currentEighthTurns: trackTileStackBlueprint
                  .singleTileBlueprints[indexSelectedSingleTile].eighthTurns,
              color: trackTileStackBlueprint
                  .singleTileBlueprints[indexSelectedSingleTile].color,
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
                        color: widget.color,
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
