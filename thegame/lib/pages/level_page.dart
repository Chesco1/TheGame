import 'package:flutter/material.dart';
import 'package:thegame/views/line_grid.dart';

class LevelPage extends StatelessWidget {
  const LevelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        color: Colors.yellow,
        child: LineGrid(),
      ),
    );
  }
}
