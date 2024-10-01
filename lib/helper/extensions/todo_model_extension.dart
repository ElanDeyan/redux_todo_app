import 'package:redux_todo_app/db/app_database.dart';
import 'package:redux_todo_app/models/todo.dart';

/// Extensions for the [Todo] class
extension TodoModelExtension on Todo {
  /// Helper method to return an [Todo] from the [TodoTable].
  static Todo fromTodoTable(TodoTable table) {
    return Todo(
      id: table.id,
      title: table.title,
      description: table.description,
      isCompleted: table.isCompleted,
      createdAtTime: table.createdAt,
    );
  }
}
