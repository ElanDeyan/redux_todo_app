import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/store/app_state.dart';

/// Reducer for the [AppState], that takes the
/// actual state, a [List] of [Todo]s, and an [TodoActions]
/// to returns a new [AppState].
AppState todoReducer(AppState actualState, TodoActions action) =>
    switch (action) {
      final FetchAllTodosAction _ => actualState,
      AddTodoAction(:final todo) => _addTaskHandler(actualState, todo),
      AddManyTodosAction(:final todos) =>
        _addManyTodosHandler(actualState, todos),
      ToggleTodoCompletionAction(:final todo) =>
        _toggleTaskCompletionHandler(actualState, todo),
      RemoveTodoAction(:final todo) => _removeTaskHandler(actualState, todo),
    };

AppState _addTaskHandler(AppState actualState, Todo todo) =>
    AppState(todos: [...actualState.todos, todo]);

AppState _addManyTodosHandler(AppState actualState, List<Todo> todosToAdd) =>
    AppState(todos: [...actualState.todos, ...todosToAdd]);

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
