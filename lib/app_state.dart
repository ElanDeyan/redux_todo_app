import 'package:redux_todo_app/models/models.dart';

/// {@template app_store}
/// App's store in redux architecture.
/// {@endtemplate}
final class AppState {
  /// {@macro app_store}
  const AppState({this.todos = const <Todo>[]});

  /// A list containing all [Todo]'s of the app.
  final List<Todo> todos;
}
