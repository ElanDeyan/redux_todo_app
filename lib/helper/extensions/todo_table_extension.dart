import 'package:redux_todo_app/db/app_database.dart';
import 'package:redux_todo_app/models/todo.dart';

/// Helper extensions for [TodoTable].
extension TodoTableExtension on TodoTable {
  /// "Factory" to creates a new [TodoTable] from a [Todo] model.
  static TodoTable fromTodoModel(Todo todo) {
    return TodoTable(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
    );
  }
}
