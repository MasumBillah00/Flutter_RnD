import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../bloc/todo_bloc/todo_app/todo_app_bloc.dart';
import '../../../../bloc/todo_bloc/todo_app/todo_app_event.dart';
import '../../../../bloc/todo_bloc/todo_app/todo_app_state.dart';
import '../../../fitness_tracker/view/screen/home_screen.dart';
import '../component/alert_dialog.dart';
import '../component/image_design.dart';
import '../note/note_taking_app.dart';
import '../todo_app_widget/icon_button_widget.dart';
import '../todo_app_widget/button_widget.dart';
import '../component/component_widget.dart';
import '../todo_app_widget/drawer_widget.dart';
import 'complete_task_screen.dart';
import 'deleted_item_screen.dart';
import 'favorite_item_screen.dart';


class ToDoAppScreen extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;

  const ToDoAppScreen({super.key,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier});

  @override
  State<ToDoAppScreen> createState() => _ToDoAppScreenState();
}

class _ToDoAppScreenState extends State<ToDoAppScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ToDoAppBloc>().add(FetchTaskList());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 1:
        return FavouriteScreen(onItemTapped: _onItemTapped,
          inactivityTimerNotifier: widget.inactivityTimerNotifier,
          graceTimerNotifier: widget.graceTimerNotifier,);
      case 2:
        return CompleteTasksScreen(onItemTapped: _onItemTapped,
          inactivityTimerNotifier: widget.inactivityTimerNotifier,
          graceTimerNotifier: widget.graceTimerNotifier,);
      case 3:
        return DeletedItemScreen(onItemTapped: _onItemTapped,
          inactivityTimerNotifier: widget.inactivityTimerNotifier,
          graceTimerNotifier: widget.graceTimerNotifier,);
      case 4:
        return  HomeScreen(
          inactivityTimerNotifier: widget.inactivityTimerNotifier,
          graceTimerNotifier: widget.graceTimerNotifier,);
      default:
        return BlocBuilder<ToDoAppBloc, TodoappState>(
          builder: (context, state) {

            switch (state.listStatus) {
              case ListStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ListStatus.failure:
                return const Center(child: Text('Something went wrong'));
              case ListStatus.success:
                return ListView.builder(
                  itemCount: state.taskItemList.length,
                  itemBuilder: (context, index) {
                    final item = state.taskItemList[index];
                    final isSelected = state.selectedList.contains(item);
                    String formattedDate = DateFormat.MMMd().format(item.date);

                    // Ensure UI is built properly here
                    return Card(
                      color: Colors.grey[700],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0,bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      context.read<ToDoAppBloc>().add(SelectItem(item: item));
                                    } else {
                                      context.read<ToDoAppBloc>().add(UnSelectItem(item: item));
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: item.value,
                                            isSelected: isSelected,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      DCustomText(
                                        text: item.description,
                                        isSelected: isSelected,
                                        showSeeMore: true,
                                      ),
                                      if (item.image.isNotEmpty) ...[
                                        const SizedBox(height: 5),
                                        ImageDesign(item: item),
                                      ],
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            context.read<ToDoAppBloc>().add(FavouriteItem(item: item));
                                          },
                                          icon: Icon(
                                            item.isFavourite ? Icons.favorite : Icons.favorite_outline,
                                            color: Colors.amberAccent,
                                            size: 30,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        CustomIconButton(
                                          icon: Icons.delete,
                                          color: Colors.red,
                                          onPressed: () {
                                            _showHideConfirmationDialog(context, item.id, item.value);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10.0,
                            right: 15.0,
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              default:
                return const Center(child: CircularProgressIndicator());

            }

          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10,),
        child: Scaffold(
          appBar: _selectedIndex == 0
              ? AppBar(
           // backgroundColor: Colors.amber.shade600,
            title: const Text(
              'TODO APP',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NoteListPage(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Note',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white, // Customize color to match your theme
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.top,
                        child: Transform.translate(
                          offset: const Offset(2, -4),
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white, // Customize color to match your theme
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          )
              : null,
          drawer: ToDo_Drawer(onItemTapped: _onItemTapped,
            inactivityTimerNotifier: widget.inactivityTimerNotifier,
            graceTimerNotifier: widget.graceTimerNotifier,),
          body: BlocConsumer<ToDoAppBloc, TodoappState>(
            listener: (context, state) {
              if (state.listStatus == ListStatus.failure && state.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return _getBody();
            },
          ),
          floatingActionButton:  FloatingActionButtonWidget(
            inactivityTimerNotifier: widget.inactivityTimerNotifier,
            graceTimerNotifier: widget.graceTimerNotifier,),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.amber[200], size: 35),
                activeIcon: Icon(Icons.home, color: Colors.amber[600], size: 35),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite, color: Colors.amber[200], size: 35),
                activeIcon: Icon(Icons.favorite, color: Colors.amber[600], size: 35),
                label: 'Favourite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_box, color: Colors.amber[200], size: 35),
                activeIcon: Icon(Icons.check_box, color: Colors.amber[600], size: 35),
                label: 'Completed Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restore_from_trash, color: Colors.amber[200], size: 35),
                activeIcon: Icon(Icons.restore_from_trash, color: Colors.amber[600], size: 35),
                label: 'RecycleBin',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
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
        context.read<ToDoAppBloc>().add(
            HideItem(id: taskId, value: taskValue, description: '', date: currentDate));
      },
    );
  }
}