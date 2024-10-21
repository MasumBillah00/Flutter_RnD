import 'package:equatable/equatable.dart';
import '../../../todo_app/model/todo_task_model.dart';

enum ListStatus { loading, success, failure, initial }

class TodoappState extends Equatable {
  final List<TodoTaskModel> taskItemList;
  final List<TodoTaskModel> hiddenTaskList;
  final List<TodoTaskModel> favouriteList;
  final List<TodoTaskModel> selectedList;
  final ListStatus listStatus;
  final String errorMessage;

  const TodoappState({
    this.taskItemList = const [],
    this.hiddenTaskList = const [],
    this.favouriteList = const [],
    this.selectedList = const [],
    this.listStatus = ListStatus.loading,
    this.errorMessage = '',
  });

  TodoappState copyWith({
    List<TodoTaskModel>? taskItemList,
    List<TodoTaskModel>? hiddenTaskList,
    List<TodoTaskModel>? favouriteList,
    List<TodoTaskModel>? selectedList,
    ListStatus? listStatus,
    String? errorMessage,
  }) {
    return TodoappState(
      taskItemList: taskItemList ?? this.taskItemList,
      hiddenTaskList: hiddenTaskList ?? this.hiddenTaskList,
      favouriteList: favouriteList ?? this.favouriteList,
      selectedList: selectedList ?? this.selectedList,
      listStatus: listStatus ?? this.listStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    taskItemList,
    hiddenTaskList,
    favouriteList,
    selectedList,
    listStatus,
    errorMessage,
  ];
}