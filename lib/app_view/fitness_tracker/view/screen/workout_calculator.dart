import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_model/fitness_model/model/workout_model.dart';
import '../../../../bloc/workout_bloc/workout_bloc.dart';
import '../../../../bloc/workout_bloc/workout_event.dart';
import '../widget/textform_field.dart';
import '../widget/workout_formfield.dart';

class WorkoutCalculator extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const WorkoutCalculator({
    super.key,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier,
  });
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

  @override
  void initState() {
    super.initState();
  }

  void _calculateCalories() {
    final duration = int.tryParse(_durationController.text)?.abs() ?? 0;
    final rate = calorieRates[dropdownValue]?.abs() ?? 0;
    final totalCalories = duration * rate;

    setState(() {
      _caloriesController.text = totalCalories.toString(); // Update controller text
    });
  }

  void _submitWorkout() {
    final workout = Workout(
      type: dropdownValue,
      duration: int.tryParse(_durationController.text)?.abs() ?? 0,
      calories: int.tryParse(_caloriesController.text)?.abs() ?? 0,
      date: DateTime.now(),
    );

    context.read<WorkoutBloc>().add(AddWorkout(workout));

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Workout added successfully!',style: TextStyle(color: Colors.black45),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK',style: TextStyle(color: Colors.black),),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                          _calculateCalories();
                        },
                      );
                    }
                  },
                ),
                WorkoutTextFormField(
                  label: 'Duration (in minutes)',
                  controller: _durationController,
                  onChanged: (text) {
                    _calculateCalories();
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
      ],
    );
  }
}
