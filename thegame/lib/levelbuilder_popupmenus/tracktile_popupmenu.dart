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

    return SizedBox(
      width: MediaQuery.of(context).size.shortestSide * 0.9,
      child: Column(
        children: [
          _ColorPickRow(
            columnIndex: widget.columnIndex,
            rowIndex: widget.rowIndex,
          ),
          _TrackTileTypeSelector(
            columnIndex: widget.columnIndex,
            rowIndex: widget.rowIndex,
            trackTileIndex: 0,
            typeAtStart:
                trackTileStackBlueprint.singleTileBlueprints.first.type,
          ), // TODO: make TrackTilePicker with type selector
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

// TODO: make tileIndexSelector here

////////////////////////////////////////////////////////////////////////////////

class _ColorPickRow extends ConsumerWidget {
  final int columnIndex;
  final int rowIndex;

  const _ColorPickRow({
    Key? key,
    required this.columnIndex,
    required this.rowIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

    return Row(
      children: [
        for (final trackColor in TrackColor.values)
          Flexible(
            child: AspectRatio(
              aspectRatio: 1.62,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: (() {
                  trackNotifier.updateTrackTileStack(
                    columnIndex: columnIndex,
                    rowIndex: rowIndex,
                    trackTileIndex: 0,
                    newColor: trackColor,
                  );
                }),
                child: Container(
                  color: trackColor.paintColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class _TrackTileTypeSelector extends ConsumerStatefulWidget {
  final int columnIndex;
  final int rowIndex;
  final int trackTileIndex;
  final TrackTileType typeAtStart;
  const _TrackTileTypeSelector({
    Key? key,
    required this.columnIndex,
    required this.rowIndex,
    required this.trackTileIndex,
    this.typeAtStart = TrackTileType.none,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TrackTileTypeSelectorState();
}

class _TrackTileTypeSelectorState
    extends ConsumerState<_TrackTileTypeSelector> {
  final int tilesPerRow = 4;
  final double spaceBetweenTiles = 5;

  late TrackTileType selectedType = widget.typeAtStart == TrackTileType.none
      ? TrackTileType.straight
      : widget.typeAtStart;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.blueGrey[50],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    for (final type in TrackTileType.values
                        .where((type) => type != TrackTileType.none))
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
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
                              color:
                                  type != selectedType ? Colors.black38 : null,
                              child: SingleTrackTile(
                                type: type,
                                eighthTurns: 0,
                                color: trackTileStackBlueprint
                                            .singleTileBlueprints.length >
                                        widget.trackTileIndex
                                    ? trackTileStackBlueprint
                                        .singleTileBlueprints[
                                            widget.trackTileIndex]
                                        .color
                                    : TrackColor.none,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Wrap(
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
                          trackTileIndex: 0,
                          newType: selectedType,
                          newEighthTurns: i,
                        );
                      }),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border:
                              _isCurrentSelectedTile(trackTileStackBlueprint, i)
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
                              color: trackTileStackBlueprint
                                  .singleTileBlueprints[widget.trackTileIndex]
                                  .color,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isCurrentSelectedTile(
      TrackTileStackBlueprint trackTileStackBlueprint, int eighthTurns) {
    return trackTileStackBlueprint
                .singleTileBlueprints[widget.trackTileIndex].type ==
            selectedType &&
        trackTileStackBlueprint
                .singleTileBlueprints[widget.trackTileIndex].eighthTurns ==
            eighthTurns;
  }
}
