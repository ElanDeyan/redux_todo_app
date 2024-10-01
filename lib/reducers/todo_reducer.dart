import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/app_state.dart';
import 'package:redux_todo_app/models/models.dart';

/// Reducer for the [AppState], that takes the
/// actual state, a [List] of [Todo]s, and an [TodoActions]
/// to returns a new [AppState].
AppState todoReducer(AppState actualState, TodoActions action) =>
    switch (action) {
      AddTodoAction(:final todo) => _addTaskHandler(actualState, todo),
      ToggleTodoCompletionAction(:final todo) =>
        _toggleTaskCompletionHandler(actualState, todo),
      RemoveTodoAction(:final todo) => _removeTaskHandler(actualState, todo),
    };

AppState _addTaskHandler(AppState actualState, Todo todo) =>
    AppState(todos: [...actualState.todos, todo]);

AppState _toggleTaskCompletionHandler(
  AppState actualState,
  Todo toggledTodo,
) {
  return AppState(
    todos: actualState.todos.map((task) {
      if (task.id == toggledTodo.id) {
        return toggledTodo;
      }
      return task;
    }).toList(),
  );
}

AppState _removeTaskHandler(AppState actualState, Todo todoToBeRemoved) {
  return AppState(
    todos: [...actualState.todos]
      ..removeWhere((task) => task.id == todoToBeRemoved.id),
  );
}
