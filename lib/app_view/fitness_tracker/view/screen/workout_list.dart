
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../bloc/workout_bloc/workout_bloc.dart';
import '../../../../bloc/workout_bloc/workout_event.dart';
import '../../../../bloc/workout_bloc/workout_state.dart'; // For date formatting

class WorkoutList extends StatelessWidget {
  const WorkoutList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Workout List'),
      // ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                       const Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text('Work Out LIst', style: TextStyle(
                             fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.black87,
                         ),),
                       ),
                      DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(
                            label: Text('Date', textAlign: TextAlign.center),
                          ),
                          DataColumn(
                            label: Text('Type', textAlign: TextAlign.center),
                          ),
                          DataColumn(
                            label: Text('Duration', textAlign: TextAlign.center),
                          ),
                          DataColumn(
                            label: Text('Calories', textAlign: TextAlign.center),
                          ),
                          DataColumn(
                            label: Text('Action', textAlign: TextAlign.center),
                          ),
                        ],
                        rows: state.workouts.map((workout) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  DateFormat('MM-dd').format(workout.date),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                Text(
                                  workout.type,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${workout.duration} min',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${workout.calories}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    if (workout.id != null) {
                                      context
                                          .read<WorkoutBloc>()
                                          .add(DeleteWorkout(workout.id!));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Unable to delete workout."),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList()
                          ..add(
                            DataRow(
                              cells: [
                                const DataCell(SizedBox(width: 0)), // Spacer
                                const DataCell(Text('Total', textAlign: TextAlign.center)),
                                DataCell(
                                  Text(
                                    '${state.workouts.fold(0, (sum, workout) => sum + workout.duration)} min',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${state.workouts.fold(0, (sum, workout) => sum + workout.calories)}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const DataCell(SizedBox(width: 0)), // Spacer
                              ],
                            ),
                          ),
                      ),
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
}
