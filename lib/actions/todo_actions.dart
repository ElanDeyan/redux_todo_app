import 'package:redux_todo_app/models/todo.dart';
import 'package:redux_todo_app/repository/todos_repository.dart';
import 'package:redux_todo_app/store/app_state.dart';

/// Superclass for app actions
sealed class TodoActions {
  const TodoActions();
}

/// {@template fetch_all_todos_action}
/// Action that represents fetching all [Todo]s in the [TodosRepository].
/// {@endtemplate}
final class FetchAllTodosAction extends TodoActions {
  /// {@macro fetch_all_todos_action}
  const FetchAllTodosAction();

  @override
  String toString() {
    return "Fetch all to-do's in database";
  }
}

/// {@template add_many_todos_action}
/// Action to add a [List] of [Todo]s in [TodosRepository].
/// {@endtemplate}
final class AddManyTodosAction extends TodoActions {
  /// {@macro add_many_todos_action}
  const AddManyTodosAction(this.todos);

  /// [Todo]s to be added.
  final List<Todo> todos;

  @override
  String toString() {
    return 'Adding many todos: $todos';
  }
}

/// {@template add_task_action}
/// Action for add a [Todo] to the [AppState]
/// {@endtemplate}
final class AddTodoAction extends TodoActions {
  /// {@macro add_task_action}
  const AddTodoAction({required this.todo});

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
final class ToggleTodoCompletionAction extends TodoActions {
  /// {@macro toggle_task_completion}
  const ToggleTodoCompletionAction({required this.todo});

  /// A [Todo] where its [Todo.isCompleted] will be negate.
  final Todo todo;

  @override
  String toString() {
    return 'Toggle the isCompleted property of $todo';
  }
}

/// {@template remove_task_action}
/// Action for remove [Todo] from the [AppState]
/// {@endtemplate}
final class RemoveTodoAction extends TodoActions {
  /// {@macro remove_task_action}
  const RemoveTodoAction({required this.todo});

  /// A [Todo] to be removed.
  final Todo todo;

  @override
  String toString() {
    return 'Remove this todo: $todo';
  }
}
