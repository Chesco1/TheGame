import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/views/line_block.dart';

class LineGrid extends ConsumerWidget {
  const LineGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutGrid(
      columnSizes: [auto, auto],
      rowSizes: [auto, auto],
      children: [
        LineBlock(),
        LineBlock(),
        LineBlock(),
        LineBlock(),
      ],
      //physics: const NeverScrollableScrollPhysics(),
    );
  }
}
