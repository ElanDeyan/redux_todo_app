import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/store/app_store.dart';
import 'package:redux_todo_app/store/store.dart';

/// Superclass for app actions
sealed class TodoActions {
  const TodoActions();
}

/// {@template add_task_action}
/// Action for add a [Todo] to the [AppStore]
/// {@endtemplate}
final class AddTask extends TodoActions {
  /// {@macro add_task_action}
  const AddTask({required this.todo});

  /// A [Todo] to be added
  final Todo todo;

  @override
  String toString() {
    return 'Add task: $todo';
  }
}

/// {@template toggle_task_completion}
/// Action for toggle [Todo.isCompleted] property.
/// {@endtemplate}
final class ToggleTaskCompletion extends TodoActions {
  /// {@macro toggle_task_completion}
  const ToggleTaskCompletion({required this.todo});

  /// A [Todo] where its [Todo.isCompleted] will be negate.
  final Todo todo;

  @override
  String toString() {
    return 'Toggle the isCompleted property of $todo';
  }
}

/// {@template remove_task_action}
/// Action for remove [Todo] from the [AppStore]
/// {@endtemplate}
final class RemoveTask extends TodoActions {
  /// {@macro remove_task_action}
  const RemoveTask({required this.todo});

  /// A [Todo] to be removed.
  final Todo todo;

  @override
  String toString() {
    return 'Remove this todo: $todo';
  }
}
