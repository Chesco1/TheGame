import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:thegame/views/track.dart';

class LevelView extends StatelessWidget {
  const LevelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        color: Colors.yellow,
        child: LayoutGrid(
          areas: '''
          track program  
        ''',
          columnSizes: [0.61.fr, 0.39.fr],
          rowSizes: [1.fr],
          children: [
            Container(
              alignment: Alignment.center,
              child: Track(
                isLevelBuilder: false,
              ),
            ).inGridArea('track')
          ],
        ),
      ),
    );
  }
}
