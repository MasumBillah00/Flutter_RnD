
import 'package:equatable/equatable.dart';
import '../../model/todo_task_model.dart';

abstract class ToDoAppEvent extends Equatable {
  const ToDoAppEvent();

  @override
  List<Object?> get props => [];
}

class FetchTaskList extends ToDoAppEvent {}

class AddTaskItem extends ToDoAppEvent {
  final TodoTaskModel item;

  const AddTaskItem({required this.item});

  @override
  List<Object?> get props => [item];
}

class ClearErrorEvent extends ToDoAppEvent {}

class FavouriteItem extends ToDoAppEvent {
  final TodoTaskModel item;

  const FavouriteItem({required this.item});

  @override
  List<Object?> get props => [item];
}

class SelectItem extends ToDoAppEvent {
  final TodoTaskModel item;

  const SelectItem({required this.item});

  @override
  List<Object?> get props => [item];
}

class UnSelectItem extends ToDoAppEvent {
  final TodoTaskModel item;

  const UnSelectItem({required this.item});

  @override
  List<Object?> get props => [item];
}

class DeleteItem extends ToDoAppEvent {
  final String id;
  const DeleteItem({required this.id});

  @override
  List<Object?> get props => [id];
}

class HideItem extends ToDoAppEvent {
  final String id;
  final String value;
  final String description;
  final DateTime date;

  const HideItem({
    required this.id,
    required this.value,
    required this.description,
    required this.date
  });

  @override
  List<Object?> get props => [id, value, description,date];
}

class FetchHiddenTasks extends ToDoAppEvent {}

class RestoreItem extends ToDoAppEvent {
  final String id;

  const RestoreItem({required this.id});

  @override
  List<Object?> get props => [id];
}
