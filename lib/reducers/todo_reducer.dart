import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/models.dart';

/// Reducer for the [AppState], that takes the
/// actual state, a [List] of [Todo]s, and an [TodoActions]
/// to generates a new State.
AppState todoReducer(AppState previousState, TodoActions action) =>
    switch (action) {
      AddTodoAction(:final todo) => _addTaskHandler(previousState, todo),
      ToggleTodoCompletionAction(:final todo) =>
        _toggleTaskCompletionHandler(previousState, todo),
      RemoveTodoAction(:final todo) => _removeTaskHandler(previousState, todo),
    };

AppState _addTaskHandler(AppState previousState, Todo todo) =>
    AppState(todos: [...previousState.todos, todo]);

AppState _toggleTaskCompletionHandler(
  AppState previousState,
  Todo toggledTodo,
) {
  return AppState(
    todos: previousState.todos.map((task) {
      if (task.id == toggledTodo.id) {
        return toggledTodo;
      }
      return task;
    }).toList(),
  );
}

AppState _removeTaskHandler(AppState previousState, Todo todoToBeRemoved) {
  return AppState(
    todos: [...previousState.todos]
      ..removeWhere((task) => task.id == todoToBeRemoved.id),
  );
}
