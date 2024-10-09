import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/workout_bloc.dart';
import '../../bloc/workout_state.dart';
import '../../model/workout_model.dart';

class WorkoutSummaryPage extends StatelessWidget {
  const WorkoutSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Summary'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            final summaryData = _aggregateDataByType(state.workouts);

            return ListView.builder(
              itemCount: summaryData.length,
              itemBuilder: (context, index) {
                final entry = summaryData.entries.elementAt(index);
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Duration: ${entry.value['duration']} min'),
                      Text('Total Calories: ${entry.value['calories']}'),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  Map<String, Map<String, int>> _aggregateDataByType(List<Workout> workouts) {
    final Map<String, Map<String, int>> data = {};

    for (var workout in workouts) {
      final type = workout.type;

      if (data.containsKey(type)) {
        data[type]!['duration'] = data[type]!['duration']! + workout.duration;
        data[type]!['calories'] = data[type]!['calories']! + workout.calories;
      } else {
        data[type] = {
          'duration': workout.duration,
          'calories': workout.calories,
        };
      }
    }
    return data;
  }
}