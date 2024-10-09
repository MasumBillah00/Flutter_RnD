// lib/blocs/workout_event.dart

import 'package:equatable/equatable.dart';
import '../model/workout_model.dart';

abstract class WorkoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWorkouts extends WorkoutEvent {}

class AddWorkout extends WorkoutEvent {
  final Workout workout;

  AddWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

class UpdateWorkout extends WorkoutEvent {
  final Workout workout;

  UpdateWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

class DeleteWorkout extends WorkoutEvent {
  final int workoutId;

  DeleteWorkout(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}