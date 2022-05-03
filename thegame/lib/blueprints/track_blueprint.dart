// The state of our StateNotifier should be immutable.
// We could also use packages like Freezed to help with the implementation.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thegame/blueprints/track_block_blueprint.dart';

@immutable
class TrackBlueprint {
  TrackBlueprint();

  // All properties should be `final` on our class.
  final trackBlockBlueprints = <TrackBlockBlueprint>[];

  // Since Todo is immutable, we implement a method that allows cloning the
  // Todo with slightly different content.

}

// The StateNotifier class that will be passed to our StateNotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
class TrackNotifier extends StateNotifier<List<TrackBlueprint>> {
  // We initialize the list of todos to an empty list
  TrackNotifier() : super([]);
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our TodosNotifier class.
final todosProvider =
    StateNotifierProvider<TrackNotifier, List<TrackBlueprint>>((ref) {
  return TrackNotifier();
});
