import 'package:autologout_biometric/app_view/fitness_tracker/view/stats/total_workout_stats.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app_model/fitness_model/model/workout_model.dart';
import '../../../../bloc/workout_bloc/workout_bloc.dart';
import '../../../../bloc/workout_bloc/workout_state.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            final workoutData = _aggregateWorkoutData(state.workouts);  // Data for the first chart
            final caloriesByTypeToday = _aggregateCaloriesByTypeToday(state.workouts);  // Data for the second chart

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Stats By Time',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  workoutData.isEmpty
                      ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                      : Expanded(
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(workoutData.keys.elementAt(value.toInt()));
                              },
                            ),
                          ),
                          rightTitles:  AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData:  FlGridData(show: true),
                        maxY: _calculateMaxY(workoutData),  // Calculate maxY
                        barGroups: _createBarGroups(workoutData),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  const Text(
                    'Calories Burned',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  caloriesByTypeToday.isEmpty
                      ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                      : Expanded(
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(caloriesByTypeToday.keys.elementAt(value.toInt()));
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData:  FlGridData(show: true),
                        maxY: _calculateMaxY(caloriesByTypeToday),  // Calculate maxY
                        barGroups: _createBarGroups(caloriesByTypeToday),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      elevation: 5,
                      color: Colors.blue,
                      shadowColor: Colors.blue,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (newContext) => BlocProvider.value(
                                value: BlocProvider.of<WorkoutBloc>(context),
                                child: const TotalWorkoutStats(),
                              ),
                            ),
                          );
                        },
                        child: const Text('Total Workout Stats'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  // First chart data aggregation: Today's workout durations by type
  Map<String, int> _aggregateWorkoutData(List<Workout> workouts) {
    final Map<String, int> data = {};
    final currentDate = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(currentDate);

    for (var workout in workouts) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      if (workoutDate == today) {
        if (data.containsKey(workout.type)) {
          data[workout.type] = data[workout.type]! + workout.duration;
        } else {
          data[workout.type] = workout.duration;
        }
      }
    }
    return data;
  }

  // Second chart data aggregation: Today's calories burned by workout type
  Map<String, int> _aggregateCaloriesByTypeToday(List<Workout> workouts) {
    final Map<String, int> data = {};
    final currentDate = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(currentDate);

    for (var workout in workouts) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      if (workoutDate == today) {
        if (data.containsKey(workout.type)) {
          data[workout.type] = data[workout.type]! + workout.calories;
        } else {
          data[workout.type] = workout.calories;
        }
      }
    }
    return data;
  }

  List<BarChartGroupData> _createBarGroups(Map<String, int> data) {
    final List<Color> barColors = [
      Colors.redAccent.shade700,
      Colors.purple.shade700,
      Colors.greenAccent.shade700,
      Colors.blue.shade900,
    ];

    // Convert entries to list and use asMap to get index along with entry
    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key; // Get the index
      final mapEntry = entry.value; // Get the actual map entry

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: mapEntry.value.toDouble(),
            color: barColors[index % barColors.length], // Assign color based on index
            width: 20,
          ),
        ],
      );
    }).toList();
  }


  double _calculateMaxY(Map<String, int> workoutData) {
    final maxValue = workoutData.values.isNotEmpty
        ? workoutData.values.reduce((a, b) => a > b ? a : b)
        : 0;
    return maxValue + (maxValue * 0.1);  // Add a 10% buffer
  }
}