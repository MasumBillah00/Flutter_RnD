import '../../database/todo_database/database_helper.dart';
import '../model/todo_task_model.dart';

class ToDoAppRepository {
  final TodoDatabaseHelper databaseHelper;

  ToDoAppRepository(this.databaseHelper);

  Future<void> addItem(TodoTaskModel item) async {
    try {
      // Check if a task with the same title already exists
      final existingTask = await databaseHelper.queryTaskByTitle(item.value);
      if (existingTask != null) {
        throw Exception('Task with title "${item.value}" already exists.');
      }
      await databaseHelper.insertTask({
        'id': item.id,
        'value': item.value,
        'description': item.description,
        'image':item.image,
        'date': item.date.toIso8601String(),
        'isDeleting': item.isDeleting ? 1 : 0,
        'isFavourite': item.isFavourite ? 1 : 0,
      });
    } catch (e) {
      // Handle exceptions (e.g., duplicate title) based on your app's needs
      rethrow; // Optionally handle or log the exception
    }
  }

  Future<List<TodoTaskModel>> fetchItems({bool includeDeleted = false}) async {
    final List<Map<String, dynamic>> maps = await databaseHelper.queryAllTasks();
    return List.generate(maps.length, (i) {
      return TodoTaskModel(
        id: maps[i]['id'],
        value: maps[i]['value'],
        description: maps[i]['description'],
        date: DateTime.parse(maps[i]['date']),
        isDeleting: maps[i]['isDeleting'] == 1,
        isFavourite: maps[i]['isFavourite'] == 1,
        image: maps[i]['image'],
      );
    }).where((task) => includeDeleted || !task.isDeleting).toList();
  }

  Future<void> updateItem(TodoTaskModel item) async {
    final db = await databaseHelper.database;
    await db.update(
      'tasks',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> hideItem(String id) async {
    final db = await databaseHelper.database;
    await db.update(
      'tasks',
      {'isDeleting': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteItemPermanently(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> restoreItem(String id) async {
    final db = await databaseHelper.database;
    await db.update(
      'tasks',
      {'isDeleting': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}