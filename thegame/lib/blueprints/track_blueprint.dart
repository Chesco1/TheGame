// The state of our StateNotifier should be immutable.
// We could also use packages like Freezed to help with the implementation.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_block_blueprint.dart';

// @immutable
// class TrackBlueprint {
//   static const int blockTypes = 2;
//   TrackBlueprint();

//   // All properties should be `final` on our class.
//   final trackBlockBlueprints = <TrackBlockBlueprint>[];
// }

// The public methods on this class will be what allow the UI to modify the state.
class TrackNotifier extends StateNotifier<List<TrackBlockBlueprint>> {
  // We initialize the list of todos to an empty list
  TrackNotifier()
      : super([
          TrackBlockBlueprint(color: Colors.red),
          TrackBlockBlueprint(color: Colors.blue),
          TrackBlockBlueprint(color: Colors.purple),
          TrackBlockBlueprint(color: Colors.green),
        ]);
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final trackBlueprintProvider =
    StateNotifierProvider<TrackNotifier, List<TrackBlockBlueprint>>((ref) {
  return TrackNotifier();
});
