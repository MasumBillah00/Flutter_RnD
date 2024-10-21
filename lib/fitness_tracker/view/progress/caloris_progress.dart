// import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/workout_bloc/workout_bloc.dart';
import '../../../bloc/workout_bloc/workout_state.dart';

import '../../model/workout_model.dart';
import 'monthly_progress.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Progress over time.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<WorkoutBloc, WorkoutState>(
              builder: (context, state) {
                if (state is WorkoutsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WorkoutsLoaded) {
                  final dailyProgress = _aggregateProgressData(state.workouts);

                  if (dailyProgress.isEmpty) {
                    return const Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  final sortedEntries = dailyProgress.entries.toList()
                    ..sort((a, b) => DateFormat('yyyy-MM-dd')
                        .parse(a.key)
                        .compareTo(DateFormat('yyyy-MM-dd').parse(b.key)));

                  final spots = sortedEntries.asMap().entries.map((entry) {
                    final index = entry.key.toDouble(); // Convert the index to double
                    final value = entry.value.value.toDouble();
                    return FlSpot(index, value);
                  }).toList();

                  final maxY = sortedEntries
                      .map((e) => e.value)
                      .reduce((a, b) => a > b ? a : b)
                      .toDouble();
                  final adjustedMaxY = maxY * 1.1;
                  // Adding 10% padding to the maxY

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0,
                            left: 12,
                            top: 12,
                            bottom: 8
                        ),
                        child: LineChart(
                          LineChartData(
                            gridData:  FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 35,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              rightTitles:  AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles:  AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),

                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final dateIndex = value.toInt();
                                    if (dateIndex >= 0 &&
                                        dateIndex < sortedEntries.length) {
                                      final dateKey = sortedEntries[dateIndex].key;
                                      return Text(
                                        DateFormat('dd').format(
                                            DateFormat('yyyy-MM-dd')
                                                .parse(dateKey)),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      );
                                    } else {
                                      return const Text('');
                                    }
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border:  Border(
                                left: BorderSide(
                                  color:  Colors.greenAccent.shade700,
                                  width: 3,
                                ),
                                bottom: BorderSide(
                                  color:  Colors.greenAccent.shade700,
                                  width: 3,
                                ),
                                top: BorderSide.none, // Remove top border
                                right: BorderSide.none, // Remove right border
                              ),
                            ),
                            minX: -0.13,
                            maxX: (sortedEntries.length - 1).toDouble(),
                            minY: 0,
                            maxY: adjustedMaxY,
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: Colors.redAccent.shade700,
                                barWidth: 2,
                                dotData:  FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Overlay custom arrow using CustomPaint
                      // Positioned.fill(
                      //   child: CustomPaint(
                      //     painter: ArrowPainter(adjustedMaxY),
                      //   ),
                      // ),
                    ],
                  );
                } else {
                  return const Center(child: Text('Something went wrong!'));
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Track your progress over time.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(child: MonthlyProgressChart()),
        ],
      ),
    );
  }

  // Function to aggregate workout progress data (e.g., calories burned)
  Map<String, int> _aggregateProgressData(List<Workout> workouts) {
    final Map<String, int> dailyProgress = {};

    for (var workout in workouts) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      if (dailyProgress.containsKey(workoutDate)) {
        dailyProgress[workoutDate] =
            dailyProgress[workoutDate]! + workout.calories;
      } else {
        dailyProgress[workoutDate] = workout.calories;
      }
    }

    return dailyProgress;
  }
}
