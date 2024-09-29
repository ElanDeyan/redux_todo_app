import 'package:redux_todo_app/models/models.dart';

/// Interface for database operations with [Todo].
abstract interface class TodosRepository {
  /// Gets all [Todo]'s.
  Future<List<Todo>> get all;

  /// Adds [Todo].
  Future<Todo?> add(Todo todo);

  /// Toggles [Todo.isCompleted] property of [Todo].
  Future<Todo?> toggleTodoCompletion(Todo todo);

  /// Removes [Todo].]
  Future<Todo?> removeTodo(Todo todo);
}
