
// lib/blocs/workout_state.dart

import 'package:equatable/equatable.dart';
import '../../fitness_tracker/model/workout_model.dart';

abstract class WorkoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorkoutsLoading extends WorkoutState {}

class WorkoutsLoaded extends WorkoutState {
  final List<Workout> workouts;

  WorkoutsLoaded(this.workouts);

  @override
  List<Object?> get props => [workouts];
}

class WorkoutError extends WorkoutState {
  final String message;

  WorkoutError(this.message);

  @override
  List<Object?> get props => [message];
}
