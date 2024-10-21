import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/workout_bloc/workout_bloc.dart';
import '../../../bloc/workout_bloc/workout_state.dart';
import '../../model/workout_model.dart';

class MonthlyProgressChart extends StatefulWidget {
  const MonthlyProgressChart({super.key});

  @override
  _MonthlyProgressChartState createState() => _MonthlyProgressChartState();
}

class _MonthlyProgressChartState extends State<MonthlyProgressChart> {
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  late List<String> months;

  @override
  void initState() {
    super.initState();
    months = List.generate(12, (index) => DateFormat('MMMM').format(DateTime(0, index + 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
            child: Card(
              elevation: 10,

              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: Colors.blueGrey.shade800,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0,),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedMonth,
                    onChanged: (newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                      });
                    },
                    items: months.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.blueGrey.shade600,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<WorkoutBloc, WorkoutState>(
              builder: (context, state) {
                if (state is WorkoutsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WorkoutsLoaded) {
                  final monthlyProgress = _aggregateMonthlyProgressData(state.workouts, selectedMonth);

                  if (monthlyProgress.isEmpty) {
                    return const Center(
                      child: Text(
                        'No data available for this month',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  final sortedEntries = monthlyProgress.entries.toList()
                    ..sort((a, b) => DateFormat('yyyy-MM-dd')
                        .parse(a.key)
                        .compareTo(DateFormat('yyyy-MM-dd').parse(b.key)));

                  final spots = sortedEntries.asMap().entries.map((entry) {
                    final index = entry.key.toDouble();
                    final value = entry.value.value.toDouble();
                    return BarChartGroupData(
                      x: index.toInt(),
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          color: Colors.blueAccent.shade700,
                          width: 15,
                        ),
                      ],
                    );
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 16.0,
                      left: 12,
                      top: 12,
                      bottom: 8,
                    ),
                    child:BarChart(
                      BarChartData(
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
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                final dateIndex = value.toInt();
                                if (dateIndex >= 0 && dateIndex < sortedEntries.length) {
                                  final dateKey = sortedEntries[dateIndex].key;
                                  return Text(
                                    DateFormat('dd').format(DateFormat('yyyy-MM-dd').parse(dateKey)),
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
                          border: Border(
                            left: BorderSide(
                              color: Colors.blueGrey.shade700,
                              width: 3,
                            ),
                            bottom: BorderSide(
                              color: Colors.blueGrey.shade700,
                              width: 3,
                            ),
                            top: BorderSide.none,
                            right: BorderSide.none,
                          ),
                        ),
                        minY: 0,

                        barGroups: spots.map((spot) {
                          return BarChartGroupData(
                            x: spot.x,
                            barRods: [
                              BarChartRodData(
                                toY: spot.barRods[0].toY,
                                width: 15,

                                gradient: LinearGradient(
                                  colors: [
                                    Colors.lightBlueAccent.shade400,
                                    Colors.blueGrey.shade700,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: 15,
                                  color: Colors.blueGrey.shade100,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        backgroundColor: Colors.white,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            // tooltipBgColor: Colors.blueGrey.shade700,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toStringAsFixed(1)}',
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),


                    ),
                  );
                } else {
                  return const Center(child: Text('Something went wrong!'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to aggregate monthly workout progress data
  Map<String, int> _aggregateMonthlyProgressData(List<Workout> workouts, String month) {
    final Map<String, int> monthlyProgress = {};
    for (var workout in workouts) {
      final workoutDate = DateFormat('yyyy-MM-dd').format(workout.date);
      if (DateFormat('MMMM').format(workout.date) == month) {
        if (monthlyProgress.containsKey(workoutDate)) {
          monthlyProgress[workoutDate] = monthlyProgress[workoutDate]! + workout.calories;
        } else {
          monthlyProgress[workoutDate] = workout.calories;
        }
      }
    }
    return monthlyProgress;
  }
}
