import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/todo_bloc/todo_app/todo_app_bloc.dart';
import '../../../../bloc/todo_bloc/todo_app/todo_app_event.dart';
import '../../../../bloc/todo_bloc/todo_app/todo_app_state.dart';
import '../component/alert_dialog.dart';
import '../constant.dart';
import '../todo_app_widget/icon_button_widget.dart';
import '../component/component_widget.dart';
import '../todo_app_widget/drawer_widget.dart';

class CompleteTasksScreen extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;
  final ValueChanged<int> onItemTapped;

  const CompleteTasksScreen({super.key, required this.onItemTapped,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier});

  @override
  State<CompleteTasksScreen> createState() => _CompleteTasksScreenState();
}

class _CompleteTasksScreenState extends State<CompleteTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Finished Task',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        drawer: ToDo_Drawer(onItemTapped: widget.onItemTapped,
          inactivityTimerNotifier:widget.inactivityTimerNotifier ,
          graceTimerNotifier: widget.graceTimerNotifier,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: BlocBuilder<ToDoAppBloc, TodoappState>(
            builder: (context, state) {
              if (state.selectedList.isEmpty) {
                return const Center(child: Text('No completed task yet'));
              }
              return ListView.builder(
                itemCount: state.selectedList.length,
                itemBuilder: (context, index) {
                  final item = state.selectedList[index];
                  final isSelected = state.selectedList.contains(item);
                  return Card(
                    color: Colors.grey[800],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: CustomText(
                        text: item.value,
                      ),
                      subtitle: DCustomText(
                        text: item.description,
                        isSelected: isSelected,
                      ),
                      trailing: CustomIconButton(
                        icon: Icons.delete,
                        // size: 30,
                        color: AppColors.deleteColor,
                        onPressed: () {
                          _showHideConfirmationDialog(context, item.id, item.value);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showHideConfirmationDialog(BuildContext context, String taskId, String taskValue) {
    final currentDate = DateTime.now();
    showConfirmationDialog(
      context: context,
      title: 'Confirm Delete',
      content: 'Are you sure you want to delete?',
      onConfirm: () {
        context.read<ToDoAppBloc>().add(HideItem(id: taskId, value: taskValue, description: '', date: currentDate));
      },
    );
  }
}