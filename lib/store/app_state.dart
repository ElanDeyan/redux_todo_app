import 'package:equatable/equatable.dart';
import 'package:redux_todo_app/models/todo.dart';

/// {@template app_store}
/// App's store in redux architecture.
/// {@endtemplate}
final class AppState extends Equatable {
  /// {@macro app_store}
  const AppState({this.todos = const <Todo>[]});

  /// A list containing all [Todo]'s of the app.
  final List<Todo> todos;

  @override
  List<Object?> get props => [todos];

  @override
  String toString() {
    return 'AppState(todos: $todos)';
  }
}
