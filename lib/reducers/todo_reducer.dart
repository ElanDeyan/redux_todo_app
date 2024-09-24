import 'package:redux_todo_app/actions/actions.dart';
import 'package:redux_todo_app/models/models.dart';
import 'package:redux_todo_app/store/app_store.dart';
import 'package:redux_todo_app/store/store.dart';

/// Reducer for the [AppStore], that takes the
/// actual state, a [List] of [Todo]s, and an [TodoActions]
/// to generates a new State.
List<Todo> todoReducer(List<Todo> previousState, TodoActions action) =>
    switch (action) {
      AddTask(:final todo) => _addTaskHandler(previousState, todo),
      ToggleTaskCompletion(:final todo) =>
        _toggleTaskCompletionHandler(previousState, todo),
      RemoveTask(:final todo) => _removeTaskHandler(previousState, todo),
    };

List<Todo> _addTaskHandler(List<Todo> previousState, Todo todo) =>
    [...previousState, todo];

List<Todo> _toggleTaskCompletionHandler(
  List<Todo> previousState,
  Todo todoToBeToggled,
) {
  return previousState.map((task) {
    if (task == todoToBeToggled) {
      return Todo(
        title: todoToBeToggled.title,
        description: todoToBeToggled.description,
        isCompleted: !todoToBeToggled.isCompleted,
      );
    }
    return task;
  }).toList();
}

List<Todo> _removeTaskHandler(List<Todo> previousState, Todo todoToBeRemoved) {
  return [...previousState]..removeWhere((task) => task == todoToBeRemoved);
}
