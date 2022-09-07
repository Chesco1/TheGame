import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_blueprint.dart';

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
        ],
      ),
    );
  }
}

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: AspectRatio(
            aspectRatio: 1,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: (() {
                final trackNotifier =
                    ref.watch(trackBlueprintProvider.notifier);

                trackNotifier.updateTrackTileStack(
                  columnIndex: columnIndex,
                  rowIndex: rowIndex,
                  trackTileIndex: 0,
                  newColor: TrackColor.none,
                );
              }),
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ),
        Flexible(
          child: AspectRatio(
            aspectRatio: 1,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: (() {
                final trackNotifier =
                    ref.watch(trackBlueprintProvider.notifier);

                trackNotifier.updateTrackTileStack(
                  columnIndex: columnIndex,
                  rowIndex: rowIndex,
                  trackTileIndex: 0,
                  newColor: TrackColor.red,
                );
              }),
              child: Container(
                color: Colors.red,
              ),
            ),
          ),
        ),
        Flexible(
          child: AspectRatio(
            aspectRatio: 1,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: (() {
                final trackNotifier =
                    ref.watch(trackBlueprintProvider.notifier);

                trackNotifier.updateTrackTileStack(
                  columnIndex: columnIndex,
                  rowIndex: rowIndex,
                  trackTileIndex: 0,
                  newColor: TrackColor.green,
                );
              }),
              child: Container(
                color: Colors.green,
              ),
            ),
          ),
        ),
        Flexible(
          child: AspectRatio(
            aspectRatio: 1,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: (() {
                final trackNotifier =
                    ref.watch(trackBlueprintProvider.notifier);

                trackNotifier.updateTrackTileStack(
                  columnIndex: columnIndex,
                  rowIndex: rowIndex,
                  trackTileIndex: 0,
                  newColor: TrackColor.blue,
                );
              }),
              child: Container(
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
