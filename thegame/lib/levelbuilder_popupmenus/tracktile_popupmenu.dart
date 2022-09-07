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
    final trackNotifier = ref.watch(trackBlueprintProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final trackColor in TrackColor.values)
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
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
                  alignment: Alignment.center,
                  color: trackColor.paintColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
