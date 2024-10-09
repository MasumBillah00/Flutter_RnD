import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/workout_bloc.dart';
import '../../bloc/workout_state.dart';
import '../../model/workout_model.dart';


class TotalWorkoutStats extends StatelessWidget {
  const TotalWorkoutStats({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Total Workout Status'),
        ),
        body: BlocBuilder<WorkoutBloc, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkoutsLoaded) {
              final caloriesData = _aggregateCaloriesData(state.workouts);

              if (caloriesData.isEmpty) {
                return const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12,left: 8,right: 16,top: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 15.0),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(caloriesData.keys.elementAt(value.toInt()));
                                },
                              ),
                            ),
                            rightTitles:AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,

                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          barGroups: _createBarGroups(caloriesData),
                          maxY: _calculateMaxY(caloriesData),
                          gridData:  FlGridData(show: true),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Calories Burned by Type (Pie Chart)',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 250,
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sections: _createPieSections(caloriesData),
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 5,
                                centerSpaceRadius: 5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildLegend(caloriesData),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }

  Map<String, int> _aggregateCaloriesData(List<Workout> workouts) {
    final Map<String, int> data = {};

    for (var workout in workouts) {
      if (data.containsKey(workout.type)) {
        data[workout.type] = data[workout.type]! + workout.calories;
      } else {
        data[workout.type] = workout.calories;
      }
    }
    return data;
  }

  List<BarChartGroupData> _createBarGroups(Map<String, int> data) {
    // Define a list of colors to use for each bar
    final List<Color> barColors = [
      Colors.redAccent.shade700,
      Colors.purple.shade700,
      Colors.greenAccent.shade700,
      Colors.blue.shade900,
    ];

    // Map data to BarChartGroupData, assigning colors based on index
    return data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
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

  // List<BarChartGroupData> _createBarGroups(Map<String, int> data) {
  //   return data.entries.map((entry) {
  //     return BarChartGroupData(
  //       x: data.keys.toList().indexOf(entry.key),
  //       barRods: [
  //         BarChartRodData(
  //           toY: entry.value.toDouble(),
  //           color: Colors.blueGrey.shade700,
  //           width: 16,
  //         ),
  //       ],
  //     );
  //   }).toList();
  // }



  List<PieChartSectionData> _createPieSections(Map<String, int> data) {
    final colors = [
      Colors.redAccent.shade700,
      Colors.purple.shade700,
      Colors.greenAccent.shade700,
      Colors.blue.shade900,
    ];

    final total = data.values.fold(0, (sum, value) => sum + value);

    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final color = colors[index % colors.length];
      final percentage = (item.value / total * 100).toStringAsFixed(0);
      final double percentageValue = item.value / total * 100;

      return PieChartSectionData(
        value: item.value.toDouble(),
        title: percentageValue >= 10 ? '$percentage%' : '',
        color: color,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white, // Make sure the text is readable on the pie element
        ),
      );
    }).toList();
  }



  List<Widget> _buildLegend(Map<String, int> data) {
    final colors = [
      Colors.redAccent.shade700,
      Colors.purple.shade700,
      Colors.greenAccent.shade700,
      Colors.blue.shade900,
    ];

    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final workoutType = entry.value.key;
      final color = colors[index % colors.length];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              workoutType,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }
}