
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/todo_app/todo_app_bloc.dart';
import '../../bloc/todo_app/todo_app_state.dart';
import '../component/component_widget.dart';
import '../todo_app_widget/drawer_widget.dart';

class FavouriteScreen extends StatefulWidget {
  final ValueNotifier<int> inactivityTimerNotifier;
  final ValueNotifier<int> graceTimerNotifier;
  final ValueChanged<int> onItemTapped;

  const FavouriteScreen({super.key, required this.onItemTapped,
    required this.inactivityTimerNotifier,
    required this.graceTimerNotifier});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Favorite Item',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          drawer: ToDo_Drawer(onItemTapped: widget.onItemTapped,
            inactivityTimerNotifier: widget.inactivityTimerNotifier,
            graceTimerNotifier: widget.graceTimerNotifier,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: BlocBuilder<ToDoAppBloc, TodoappState>(
              builder: (context, state) {
                if (state.listStatus == ListStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.listStatus == ListStatus.failure) {
                  return const Center(child: Text('Failed to load tasks'));
                } else if (state.favouriteList.isEmpty) {
                  return const Center(child: Text('No favorite items'));
                } else {
                  return ListView.builder(
                    itemCount: state.favouriteList.length,
                    itemBuilder: (context, index) {
                      final item = state.favouriteList[index];
                      final isSelected = state.selectedList.contains(item);
                      String formattedDate = DateFormat.MMMd().format(item.date);

                      return Card(
                        color: Colors.grey[800],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          // title: CustomText(
                          //   text: item.value,
                          // ),
                          // subtitle: DCustomText(
                          //   text: item.description,
                          //   isSelected: isSelected,
                          // ),
                          title: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: item.value,
                                    isSelected: isSelected,

                                  ),
                                  Text(formattedDate),
                                ],
                              ),
                              const SizedBox(height: 5),
                              // DCustomText(
                              //   text: item.description,
                              //   isSelected: isSelected,
                              // ),
                              // if (item.image.isNotEmpty) ...[
                              //   const SizedBox(height: 5),
                              //   Image.file(
                              //     File(item.image),
                              //     height: 180,
                              //
                              //   ),
                              // ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 155,
                                    child: DCustomText(
                                      text: item.description,
                                      isSelected: isSelected,
                                      showSeeMore: true,
                                    ),
                                  ),
                                  const SizedBox(width: 10,),

                                  if (item.image.isNotEmpty) ...[
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 150,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12), // Adjust the border radius as needed
                                          border: Border.all(
                                            color: Colors.blue, // Set the border color
                                            width: 2, // Set the border width
                                          ),
                                          shape: BoxShape.rectangle, // Can be BoxShape.circle for circular images
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12), // Match the border radius here
                                          child: Image.file(
                                            File(item.image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),

                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
