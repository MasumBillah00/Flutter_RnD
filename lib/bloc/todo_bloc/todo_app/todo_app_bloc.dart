import 'package:autologout_biometric/bloc/todo_bloc/todo_app/todo_app_event.dart';
import 'package:autologout_biometric/bloc/todo_bloc/todo_app/todo_app_state.dart';
import 'package:bloc/bloc.dart';
import '../../../app_model/todo_model/model/todo_task_model.dart';
import '../../../repository/todo_repository/repository/todo_repository.dart';

class ToDoAppBloc extends Bloc<ToDoAppEvent, TodoappState> {
  final ToDoAppRepository toDoAppRepository;

  ToDoAppBloc(this.toDoAppRepository) : super(const TodoappState()) {
    on<FetchTaskList>(_fetchList);
    on<FetchHiddenTasks>(_fetchHiddenTasks);
    on<AddTaskItem>(_handleAddTaskItem);
    on<FavouriteItem>(_handleFavouriteItem);
    on<DeleteItem>(_deleteItem);
    on<HideItem>(_hideItem);
    on<RestoreItem>(_restoreItem);
    on<SelectItem>(_selectItem);
    on<UnSelectItem>(_unSelectItem);
    on<ClearErrorEvent>(_clearError);
  }

  void _fetchList(FetchTaskList event, Emitter<TodoappState> emit) async {
    emit(state.copyWith(listStatus: ListStatus.loading)); // Add loading state
    try {
      final taskList = await toDoAppRepository.fetchItems();
      final taskItemList = taskList.where((item) => item.isFavourite).toList();
      emit(state.copyWith(
        taskItemList: List.from(taskList),
        favouriteList: taskItemList,
        listStatus: ListStatus.success,
      ));
    } catch (_) {
      emit(state.copyWith(listStatus: ListStatus.failure));
    }
  }

  void _handleAddTaskItem(AddTaskItem event, Emitter<TodoappState> emit) async {
    try {
      await toDoAppRepository.addItem(event.item);
      final taskList = await toDoAppRepository.fetchItems();
      final favouriteItems = taskList.where((item) => item.isFavourite).toList();
      emit(state.copyWith(taskItemList: List.from(taskList), favouriteList: favouriteItems, listStatus: ListStatus.success));
    } catch (e) {
      if (e is Exception && e.toString().contains('already exists')) {
        emit(state.copyWith(listStatus: ListStatus.failure, errorMessage: 'Task with this title already exists.'));
      } else {
        emit(state.copyWith(listStatus: ListStatus.failure, errorMessage: 'Failed to add task'));
      }
    }
  }

  void _clearError(ClearErrorEvent event, Emitter<TodoappState> emit) {
    emit(state.copyWith(listStatus: ListStatus.initial, errorMessage: ''));
  }

  void _handleFavouriteItem(FavouriteItem event, Emitter<TodoappState> emit) async {
    try {
      final updatedItem = event.item.copyWith(isFavourite: !event.item.isFavourite);

      // Preserve the selected state
      final updatedSelectedList = List<TodoTaskModel>.from(state.selectedList);
      if (state.selectedList.contains(event.item)) {
        updatedSelectedList.remove(event.item);
        updatedSelectedList.add(updatedItem);
      }

      await toDoAppRepository.updateItem(updatedItem);
      final taskList = await toDoAppRepository.fetchItems(); // By default, hidden items are excluded
      final favouriteItems = taskList.where((item) => item.isFavourite).toList();
      emit(state.copyWith(
        taskItemList: taskList,
        favouriteList: favouriteItems,
        selectedList: updatedSelectedList,
      ));
    } catch (_) {
      emit(state.copyWith(listStatus: ListStatus.failure));
    }
  }

  void _deleteItem(DeleteItem event, Emitter<TodoappState> emit) async {
    try {
      await toDoAppRepository.deleteItemPermanently(event.id);
      final taskList = await toDoAppRepository.fetchItems(includeDeleted: true);
      final filteredHiddenTasks = taskList.where((task) => task.isDeleting).toList();

      emit(state.copyWith(
        taskItemList: List.from(taskList),
        hiddenTaskList: List.from(filteredHiddenTasks),
      ));
    } catch (_) {
      emit(state.copyWith(listStatus: ListStatus.failure));
    }
  }

  void _hideItem(HideItem event, Emitter<TodoappState> emit) async {
    try {
      await toDoAppRepository.hideItem(event.id);

      final taskList = await toDoAppRepository.fetchItems();
      final hiddenItem = taskList.firstWhere(
            (item) => item.id == event.id,
        orElse: () => TodoTaskModel(
          id: event.id,
          value: event.value,
          description: event.description,


          date: event.date,
          isFavourite: false,
          isDeleting: true,
        ),
      );

      // Remove the hidden item from the visible list
      final updatedTaskList = taskList.where((item) => !item.isDeleting).toList();
      final favouriteItems = updatedTaskList.where((item) => item.isFavourite).toList();

      final updatedSelectedList = List<TodoTaskModel>.from(state.selectedList)..removeWhere((item) => item.id == event.id);

      emit(state.copyWith(
        taskItemList: updatedTaskList,
        favouriteList: favouriteItems,
        hiddenTaskList: List.from(state.hiddenTaskList)..add(hiddenItem),
        selectedList: updatedSelectedList,
      ));
    } catch (_) {
      emit(state.copyWith(listStatus: ListStatus.failure));
    }
  }

  void _fetchHiddenTasks(FetchHiddenTasks event, Emitter<TodoappState> emit) async {
    try {
      final hiddenTaskList = await toDoAppRepository.fetchItems(includeDeleted: true);
      final filteredHiddenTasks = hiddenTaskList.where((task) => task.isDeleting).toList();
      emit(state.copyWith(
        hiddenTaskList: List.from(filteredHiddenTasks),
        listStatus: ListStatus.success,
      ));
    } catch (_) {
      emit(state.copyWith(listStatus: ListStatus.failure));
    }
  }

  void _restoreItem(RestoreItem event, Emitter<TodoappState> emit) async {
    try {
      await toDoAppRepository.restoreItem(event.id);
      final taskList = await toDoAppRepository.fetchItems();
      final restoredItem = taskList.firstWhere((item) => item.id == event.id);

      if (restoredItem.isFavourite) {
        final updatedItem = restoredItem.copyWith(isFavourite: false);
        await toDoAppRepository.updateItem(updatedItem);
        // Fetch the updated list again after modifying the restored item's favorite status
        final updatedTaskList = await toDoAppRepository.fetchItems();
        emit(state.copyWith(
          taskItemList: updatedTaskList,
          favouriteList: updatedTaskList.where((item) => item.isFavourite).toList(),
          hiddenTaskList: state.hiddenTaskList.where((task) => task.id != event.id).toList(),
        ));
      } else {
        emit(state.copyWith(
          taskItemList: taskList,
          favouriteList: taskList.where((item) => item.isFavourite).toList(),
          hiddenTaskList: state.hiddenTaskList.where((task) => task.id != event.id).toList(),
        ));
      }
    } catch (_) {
      emit(state.copyWith(listStatus: ListStatus.failure));
    }
  }

  void _selectItem(SelectItem event, Emitter<TodoappState> emit) async {
    final updatedList = List<TodoTaskModel>.from(state.selectedList)..add(event.item);
    emit(state.copyWith(selectedList: updatedList));
  }

  void _unSelectItem(UnSelectItem event, Emitter<TodoappState> emit) async {
    final updatedList = List<TodoTaskModel>.from(state.selectedList)..remove(event.item);
    emit(state.copyWith(selectedList: updatedList));
  }
}