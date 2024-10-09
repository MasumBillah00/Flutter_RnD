

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/workout_bloc.dart';
import '../../bloc/workout_event.dart';
import '../../model/workout_model.dart';
import '../../widget/textform_field.dart';
import '../../widget/workout_formfield.dart';

class WorkoutCalculator extends StatefulWidget {
  const WorkoutCalculator({super.key});

  @override
  State<WorkoutCalculator> createState() => _WorkoutCalculatorState();
}

class _WorkoutCalculatorState extends State<WorkoutCalculator> {
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  String dropdownValue = 'Select Workout Type';

  final Map<String, int> calorieRates = {
    'Running': 10,
    'Walking': 5,
    'PushUP': 8,
    'Endurance': 7,
  };
  //late TimerManager _timerManager;

  // int _remainingTime = 60; // Example countdown starting from 60 seconds

  @override
  void initState() {
    super.initState();
   // _timerManager = TimerManager(
   //      context: context,
   //      initialTime: 60,
   //      onTick: _updateTimerDisplay
   //  );
   // _timerManager.startLogoutTimer(); // Start timer using TimerManager
  }
  void _updateTimerDisplay() {
    setState(() {}); // Trigger a rebuild to update the timer display
  }



  void _calculateCalories() {
    final duration = int.tryParse(_durationController.text) ?? 0;
    final rate = calorieRates[dropdownValue] ?? 0;
    final totalCalories = duration * rate;

    setState(() {
      _caloriesController.text = totalCalories.toString(); // Update controller text
    });
  }



  void _submitWorkout() {
    final workout = Workout(
      type: dropdownValue,
      duration: int.tryParse(_durationController.text) ?? 0,
      calories: int.tryParse(_caloriesController.text) ?? 0,
      date: DateTime.now(),
    );

    context.read<WorkoutBloc>().add(AddWorkout(workout));

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Workout added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    // Clear fields after submission
    setState(() {
      dropdownValue = 'Select Workout Type';

      _durationController.clear();
      _caloriesController.clear();
    });
  }

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    // _timerManager.cancelTimer(); // Cancel timer on dispose
    //_timerManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Workout Calculator',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                WorkoutFormField(
                  label: 'Workout Type',
                  dropdownValue: dropdownValue,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(
                            () {
                          dropdownValue = newValue;
                          _calculateCalories(); // Recalculate calories when workout type changes
                        },
                      );
                    }
                  },
                ),
                WorkoutTextFormField(
                  label: 'Duration (in minutes)',
                  controller: _durationController,
                  onChanged: (text) {
                    _calculateCalories(); // Recalculate calories when duration changes
                  },
                ),
                WorkoutTextFormField(
                  label: 'Burn Calories',
                  controller: _caloriesController,
                  readOnly: true,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitWorkout,
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        // Positioned(
        //   top: 100,
        //   right: 10,
        //   child: Text(
        //     'Time left: ${_timerManager.remainingTime} seconds',
        //     style: const TextStyle(
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.redAccent,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
