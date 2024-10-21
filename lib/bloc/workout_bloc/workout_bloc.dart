// lib/blocs/workout_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../fitness_tracker/model/workout_model.dart';
import '../../fitness_tracker/repository/workout_repository.dart';
import 'workout_event.dart';
import 'workout_state.dart';


class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository workoutRepository;

  WorkoutBloc(this.workoutRepository) : super(WorkoutsLoading()) {
    on<LoadWorkouts>(_onLoadWorkouts);
    on<AddWorkout>(_onAddWorkout);
    on<UpdateWorkout>(_onUpdateWorkout);
    on<DeleteWorkout>(_onDeleteWorkout);
  }

  Future<void> _onLoadWorkouts(
      LoadWorkouts event,
      Emitter<WorkoutState> emit,
      ) async {
    try {
      final workouts = await workoutRepository.getWorkouts();
      emit(WorkoutsLoaded(workouts));
    } catch (e) {
      emit(WorkoutError("Failed to load workouts"));
    }
  }

  Future<void> _onAddWorkout(
      AddWorkout event,
      Emitter<WorkoutState> emit,
      ) async {
    if (state is WorkoutsLoaded) {
      final List<Workout> updatedWorkouts = List.from((state as WorkoutsLoaded).workouts)
        ..add(event.workout);

      await workoutRepository.insertWorkout(event.workout);
      emit(WorkoutsLoaded(updatedWorkouts));
    }
  }

  Future<void> _onUpdateWorkout(
      UpdateWorkout event,
      Emitter<WorkoutState> emit,
      ) async {
    if (state is WorkoutsLoaded) {
      final List<Workout> updatedWorkouts = (state as WorkoutsLoaded).workouts.map((workout) {
        return workout.id == event.workout.id ? event.workout : workout;
      }).toList();

      await workoutRepository.updateWorkout(event.workout);
      emit(WorkoutsLoaded(updatedWorkouts));
    }
  }

  Future<void> _onDeleteWorkout(
      DeleteWorkout event,
      Emitter<WorkoutState> emit,
      ) async {
    if (state is WorkoutsLoaded) {
      final List<Workout> updatedWorkouts = (state as WorkoutsLoaded).workouts
          .where((workout) => workout.id != event.workoutId)
          .toList();

      await workoutRepository.deleteWorkout(event.workoutId);
      emit(WorkoutsLoaded(updatedWorkouts));
    }
  }
}