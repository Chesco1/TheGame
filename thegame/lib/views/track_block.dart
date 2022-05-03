import 'package:flutter/material.dart';

class TrackBlock extends StatelessWidget {
  const TrackBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(color: Colors.blue),
    );
  }
}
