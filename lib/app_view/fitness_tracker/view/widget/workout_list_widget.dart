import 'package:flutter/material.dart';

import '../../../../app_model/fitness_model/model/workout_model.dart';

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;

  const WorkoutList({super.key, required this.workouts});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        return ListTile(
          title: Text(workout.type),
          subtitle: Text(
              'Duration: ${workout.duration} mins, Calories: ${workout.calories}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Handle workout deletion
            },
          ),
          onTap: () {
            // Navigate to a screen to edit the workout
          },
        );
      },
    );
  }
}
